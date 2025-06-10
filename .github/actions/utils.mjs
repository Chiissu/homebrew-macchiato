import https from "https";
import crypto from "crypto";

export function fetchAndHash(url) {
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

export function fetch(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = "";

      res.on("data", (chunk) => {
        data += chunk;
      });

      res.on("end", () => {
        let res = JSON.parse(data);
        resolve(res);
      });
    });
  });
}
