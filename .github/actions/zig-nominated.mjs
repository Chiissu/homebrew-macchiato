import https from "https";
import fs from "fs";

export default function () {
  return new Promise((resolve, reject) => {
    https.get("https://machengine.org/zig/index.json", (res) => {
      let data = "";

      // A chunk of data has been received.
      res.on("data", (chunk) => {
        data += chunk;
      });

      // The whole response has been received.
      res.on("end", async () => {
        let res = JSON.parse(data);
        resolve(await check(res));
      });
    });
  });
}

async function check(data) {
  const path = "Formula/zig-nominated.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"[\d.]+-dev\.[+-\w]+"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");
  const remoteVer = data["mach-latest"].version;
  if (localVer == remoteVer) {
    console.log("zig-nominated is up to date");
    return "";
  }

  file = file.replace(verMatch, `"${remoteVer}"`);

  let replacementIndex = -1;
  const newSHA = [
    data["mach-latest"]["aarch64-macos"].shasum,
    data["mach-latest"]["x86_64-macos"].shasum,
    data["mach-latest"]["aarch64-linux"].shasum,
    data["mach-latest"]["x86_64-linux"].shasum,
  ];
  file = file.replace(/sha256 "([a-f]|\d)*"/g, () => {
    replacementIndex++;
    return `sha256 "${newSHA[replacementIndex]}"`;
  });

  fs.writeFileSync(path, file);

  return `- Update zig-nominated to ${remoteVer}\n`;
}
