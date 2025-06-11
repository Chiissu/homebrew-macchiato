import fs from "fs";
import { fetch } from "./utils.mjs";

export default async function (octokit) {
  const [version, zigUpdated] = await checkZig(
    await fetch("https://ziglang.org/download/index.json"),
  );
  const zlsVersion = await checkZls(
    await fetch(
      `https://releases.zigtools.org/v1/zls/select-version?zig_version=${encodeURIComponent(version)}&compatibility=only-runtime`,
    ),
  );
  return (
    (zigUpdated ? `- Update zig-nightly to ${version}\n` : "") +
    (zlsVersion == null ? "" : `- Update zls-nightly to ${zlsVersion}\n`)
  );
}

async function checkZig(data) {
  const path = "Formula/zig-nightly.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"[\d.]+-dev\.[+-\w]+"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");
  const remoteVer = data.master.version;
  if (localVer == remoteVer) {
    console.log("zig-nightly is up to date");
    return [remoteVer, false];
  }

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

  return [remoteVer, true];
}

async function checkZls(data) {
  const path = "Formula/zls-nightly.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"[\d.]+-dev\.[+-\w]+"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");
  const remoteVer = data.version;
  if (localVer == remoteVer) {
    console.log("zls-nightly is up to date");
    return null;
  }

  file = file.replace(verMatch, `"${remoteVer}"`);

  let replacementIndex = -1;
  const newSHA = [
    data["aarch64-macos"].shasum,
    data["x86_64-macos"].shasum,
    data["aarch64-linux"].shasum,
    data["x86_64-linux"].shasum,
  ];
  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    replacementIndex++;
    return `sha256 "${newSHA[replacementIndex]}"`;
  });

  fs.writeFileSync(path, file);

  return remoteVer;
}
