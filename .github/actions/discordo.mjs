import fs from "fs";
import { Octokit } from "octokit";
import https from "https";
import crypto from "crypto";

const baseDlLink = "https://nightly.link/ayn2op/discordo/actions/artifacts/";
const osMap = {
  discordo_macOS_ARM64: 0,
  discordo_macOS_X64: 1,
  discordo_Linux_X64: 2,
};

export default async function () {
  const path = "Formula/discordo.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"[\d.]+-[\d|a-f]+"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "").split("-")[1];

  const octokit = new Octokit();
  const owner = "ayn2op",
    repo = "discordo";
  const workflow = (
    await octokit.rest.actions.listWorkflowRuns({
      owner,
      repo,
      workflow_id: "ci.yml",
      branch: "main",
      status: "success",
      per_page: 1,
    })
  ).data.workflow_runs[0];
  const commit = workflow.head_commit.id.substring(0, 7);

  if (commit == localVer) {
    console.log("discordo is up to date");
    return "";
  }

  const artifacts = (
    await octokit.rest.actions.listWorkflowRunArtifacts({
      owner,
      repo,
      run_id: workflow.id,
    })
  ).data.artifacts;
  let results = [];
  for (let artifact of artifacts) {
    if (artifact.name == "discordo_Windows_X64") continue;
    const downloadLink = baseDlLink + artifact.id + ".zip";
    results[osMap[artifact.name]] = {
      link: downloadLink,
      sha: await fetchAndHash(downloadLink),
    };
  }

  file = file.replace(verMatch, `"0.1.0-${commit}"`);
  let i = -1;
  file = file.replace(/url "https:\/\/nightly\.link\/.+.zip"/g, () => {
    i++;
    return `url "${results[i].link}"`;
  });
  i = -1;
  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    i++;
    return `sha256 "${results[i].sha}"`;
  });
  fs.writeFileSync(path, file);
  return `- Update discordo to 0.1.0-${commit}\n`;
}

function fetchAndHash(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, (res) => {
        const hash = crypto.createHash("sha256").setEncoding("hex");
        https.get(res.headers.location, (res2) => {
          res2.pipe(hash);
          res2.on("end", () => {
            hash.end();
            resolve(hash.read());
          });
        });
      })
      .on("error", (err) => {
        reject(err);
      });
  });
}
