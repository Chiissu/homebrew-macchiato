import fs from "fs";
import { fetchAndHash } from "./utils.mjs";

const path = "Formula/zig-nightly.rb";
const verMatch = /"0\.0\.0-......."/;

export default async function (octokit) {
  const last_commit = await octokit.rest.repos.listCommits({
    owner: "jetzig-framework",
    repo: "jetzig",
    path: "cli/",
    per_page: 1,
  });

  var file = fs.readFileSync(path).toString();

  const latestVer = last_commit.data.sha.slice(0, 7);
  const currVer = file.match(verMatch)[0].slice(7, 14);

  if (latestVer == currVer) {
    console.log("jetzig is up to date");
    return "";
  }

  file = file.replace(verMatch, `"0.0.0-${latestVer}"`);

  let results = [];
  for (let url of t
    .match(/url "https:\/\/jetzig.dev\/downloads\/build-.+.zip"/g)
    .map((item) => item.slice(5, -1))) {
    results.push(await fetchAndHash(url));
  }

  let i = -1;
  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    i++;
    return `sha256 "${results[i]}"`;
  });

  fs.writeFileSync(path, file);

  return `- Update jetzig to 0.0.0-${latestVer}\n`;
}
