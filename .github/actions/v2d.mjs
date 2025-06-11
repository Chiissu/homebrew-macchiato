import fs from "fs";
import { fetchAndHash } from "./utils.mjs";

export default async function (octokit) {
  const path = "Formula/v2d.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"\d\.\d\.\d"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");

  const owner = "Chiissu",
    repo = "v2d";
  const release = (
    await octokit.rest.repos.getLatestRelease({
      owner,
      repo,
    })
  ).data;

  const version = release.tag_name.replace("v", "");

  if (version == localVer) {
    console.log("v2d is up to date");
    return "";
  }

  const sha = await fetchAndHash(
    `https://github.com/Chiissu/v2d/archive/refs/tags/v${version}.tar.gz`,
  );

  file = file.replace(verMatch, `"${version}"`);

  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    return `sha256 "${sha}"`;
  });

  fs.writeFileSync(path, file);
  return `- Update \`v2d\` to ${version}\n`;
}
