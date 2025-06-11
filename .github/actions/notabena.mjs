import fs from "fs";
import https from "https";
import crypto from "crypto";
import { fetchAndHash } from "./utils.mjs";

export default async function (octokit) {
  const path = "Formula/notabena.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"\d\.\d\.\d"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");

  const owner = "ThatFrogDev",
    repo = "notabena";
  const release = (
    await octokit.rest.repos.getLatestRelease({
      owner,
      repo,
    })
  ).data;

  const version = release.tag_name.replace("v", "");

  if (version == localVer) {
    console.log("notabena is up to date");
    return "";
  }

  const sha = await fetchAndHash(
    `https://github.com/ThatFrogDev/notabena/archive/refs/tags/v${version}.tar.gz`,
  );

  file = file.replace(verMatch, `"${version}"`);

  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    return `sha256 "${sha}"`;
  });

  //fs.writeFileSync(path, file);
  return `- Update \`notabena\` to ${version}\n`;
}
