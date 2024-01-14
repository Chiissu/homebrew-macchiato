const https = require("https");
const fs = require("fs");

module.exports = new Promise((resolve, reject) => {
  https.get("https://ziglang.org/download/index.json", (res) => {
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
})

async function check(data) {
  const path = "Formula/zig-nightly.rb";
  var file = fs.readFileSync(path).toString();
  const verMatch = /"[\d.]+-dev\.[+-\w]+"/;
  const localVer = file.match(verMatch)[0].replaceAll('"', "");
  const remoteVer = data.master.version;
  if (localVer == remoteVer) {
    console.log("Zig is up to date");
    return ""
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

  return `- Update zig to ${remoteVer}\n`;
}
