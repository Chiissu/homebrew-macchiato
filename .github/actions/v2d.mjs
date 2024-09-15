import fs from "fs";
import { Octokit } from "octokit";
import https from "https";
import crypto from "crypto";

export default async function () {
  const path = "Formula/v2d.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"\d\.\d\.\d"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");

  const octokit = new Octokit();
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

  const sha = fetchAndHash(
    `https://github.com/Chiissu/v2d/archive/refs/tags/v${version}.tar.gz`,
  );

  file = file.replace(verMatch, `"${version}"`);

  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    return `sha256 "${sha}"`;
  });

  //fs.writeFileSync(path, file);
  return `- Update v2d to ${version}\n`;
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
