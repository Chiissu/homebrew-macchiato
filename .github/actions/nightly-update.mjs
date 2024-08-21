import { execSync } from "child_process";
import { Octokit } from "octokit";

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

  const octokit = new Octokit();
  const [owner, repo] = process.env.GITHUB_REPOSITORY.split("/");
  octokit.pulls.create({
    owner,
    repo,
    base: "main",
    head: branchName,
    title: `Nightly update: ${dateString}`,
    body: results.join(""),
  });
})();
