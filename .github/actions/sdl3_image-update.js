const https = require("https");
const fs = require("fs");

const verMatch = /"([a-f]|[0-9])+"/;

module.exports = new Promise((resolve, reject) => {
  https.get(
    {
      path: "/repos/libsdl-org/SDL/branches/main",
      host: "api.github.com",
      headers: { "User-Agent": "Chiissu-Macchiato-Updater/1.0.0" },
    },
    (res) => {
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
    },
  );
});

async function check(data) {
  const path = "Formula/sdl3_image-nightly.rb";
  var file = fs.readFileSync(path).toString();
  const localVer = file.match(verMatch)[0].replaceAll('"', "");
  const remoteVer = data.commit.sha;

  if (localVer == remoteVer) {
    console.log("SDL3_Image is up to date");
    return "";
  }

  file = file.replace(verMatch, `"${remoteVer}"`);
  fs.writeFileSync(path, file);

  return `- Update SDL3_Image to ${remoteVer}\n`;
}
