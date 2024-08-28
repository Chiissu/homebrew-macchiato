import { execSync } from "child_process";
import { Octokit } from "octokit";
import { Octokit as Action } from "@octokit/action";

const formulae = ["zig-nightly", "zig-nominated", "discordo", "notabena"];

(async () => {
  const dateString = new Date()
    .toLocaleDateString("en-GB", { day: "numeric", month: "short" })
    .replace(" ", "-");
  const branchName = "nightly_update_" + dateString;
  execSync(`git checkout -b "${branchName}"`);

  const promises = formulae.map(async (formula) => {
    const module = await import(`./${formula}.mjs`);
    return module.default();
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

  const action = new Action();
  action.pulls.create({
    owner,
    repo,
    base: "main",
    head: branchName,
    title: `Nightly update: ${dateString}`,
    body: results.join(""),
  });
  const octokit = new Octokit();
  const pulls = (
    await octokit.rest.pulls.list({
      owner,
      repo,
      state: "open",
    })
  ).data;
  for (let pull of pulls) {
    if (!pull.title.startsWith("Nightly update: ")) continue;
    console.log(pull.user.id);
    octokit.rest.pulls.update({
      owner,
      repo,
      pull_number: pull.pull_number,
      state: "closed",
    });
  }
})();
