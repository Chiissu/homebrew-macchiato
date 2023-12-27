const https = require("https");
const fs = require("fs");
const { execSync } = require("child_process");
const { Octokit } = require("@octokit/action");

https.get("https://ziglang.org/download/index.json", (res) => {
  let data = "";

  // A chunk of data has been received.
  res.on("data", (chunk) => {
    data += chunk;
  });

  // The whole response has been received.
  res.on("end", () => {
    let res = JSON.parse(data);
    check(res);
  });
});

async function check(data) {
  if (!data.master.version.startsWith("0.12")) {
    console.error("Zig master is no longer on 0.12, please update");
    process.exit(1);
  }
  const path = "Formula/z/zig@0.12.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"[\d.]+[+-\w]+"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");
  const remoteVer = (() => {
    let digits = data.master.version.split(/\.|-/);
    return digits[2] + "." + digits[4];
  })();
  if (localVer == remoteVer) return console.log("Nightly is up to date");

  const dateString = new Date()
      .toLocaleDateString("en-GB", { day: "numeric", month: "short" })
      .replace(" ", "-")
  const branchName = "nightly_update_" + dateString;
  execSync(`git checkout -b "${branchName}"`);

  file = file.replace(verMatch, `"${remoteVer}"`);

  let replacementIndex = -1;
  const newSHA = [
    data.master["aarch64-macos"].shasum,
    data.master["x86_64-macos"].shasum,
    data.master["aarch64-linux"].shasum,
    data.master["x86_64-linux"].shasum,
  ];
  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    replacementIndex++;
    return `sha256 "${newSHA[replacementIndex]}"`;
  });

  fs.writeFileSync(path, file);

  execSync(
    ` git config --global user.name "froxcey";
      git config --global user.email "danichen204@gmail.com";
      git add -A;
      git commit -m "[Autoupdate]: Sync zig@0.12 to ${remoteVer}";
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
    body: `- Update Zig@0.12 to ${remoteVer}`,
  });
}
