import { execSync } from "child_process";
import { Octokit } from "octokit";
import { createActionAuth } from "@octokit/auth-action";

const formulae = [
  "zig-nightly",
  "zig-nominated",
  "discordo",
  "notabena",
  "v2d",
  "jetzig",
];

(async () => {
  const dateString = new Date()
    .toLocaleDateString("en-GB", { day: "numeric", month: "short" })
    .replace(" ", "-");
  const branchName = "nightly_update_" + dateString;
  execSync(`git checkout -b "${branchName}"`);

  const octokit = new Octokit({
    authStrategy: createActionAuth,
  });

  const promises = formulae.map(async (formula) => {
    const module = await import(`./${formula}.mjs`);
    return module.default(octokit);
  });

  const results = await Promise.all(promises);

  execSync(
    ` git config --global user.name "froxcey";
      git config --global user.email "danichen204@gmail.com";
      git add -A;
      git commit -m "[Autoupdate]: ${branchName}";
      git push -f origin ${branchName};`,
  );

  const [owner, repo] = process.env.GITHUB_REPOSITORY.split("/");
  const current_pull = await octokit.rest.pulls.create({
    owner,
    repo,
    base: "main",
    head: branchName,
    title: `Nightly update: ${dateString}`,
    body: results.join(""),
  });
  const pulls = (
    await octokit.rest.pulls.list({
      owner,
      repo,
      state: "open",
    })
  ).data;
  for (let pull of pulls) {
    if (pull.user.id != 41898282) continue;
    if (!pull.title.startsWith("Nightly update: ")) continue;
    if (pull.id == current_pull.id) continue;
    octokit.rest.issues.createComment({
      owner,
      repo,
      issue_number: pull.number,
      body: "Closing due to inactivity",
    });
    octokit.rest.pulls.update({
      owner,
      repo,
      pull_number: pull.number,
      state: "closed",
    });
  }
})();
