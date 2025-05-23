import http from 'k6/http';
//import { sleep } from 'k6';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 }, // below normal load
    { duration: '3m', target: 100 },
    //{ duration: '1m', target: 200 }, // normal load
    //{ duration: '1m', target: 200 },
    //{ duration: '1m', target: 300 }, // around the breaking point
    //{ duration: '1m', target: 300 },
    //{ duration: '1m', target: 400 }, // beyond the breaking point
    //{ duration: '1m', target: 400 },
    //{ duration: '1m', target: 0 }, // scale down. Recovery stage.
  ],
};

// export default function () {
//   //const BASE_URL = 'http://172.17.0.3'; // make sure this is not production
//   const BASE_URL = 'http://172.19.0.2:8080'; // make sure this is not production

//   const responses = http.batch([
//     ['GET', `${BASE_URL}/index.html`, null, { tags: { name: 'PublicCrocs' } }],
//     // ['GET', `${BASE_URL}/2.png`, null, { tags: { name: 'PublicCrocs' } }],
//     // ['GET', `${BASE_URL}/3.png`, null, { tags: { name: 'PublicCrocs' } }],
//     // ['GET', `${BASE_URL}/4.jpg`, null, { tags: { name: 'PublicCrocs' } }],
//     // ['GET', `${BASE_URL}/5.jpg`, null, { tags: { name: 'PublicCrocs' } }],
//     // ['GET', `${BASE_URL}/6.png`, null, { tags: { name: 'PublicCrocs' } }],
//   ]);

//   sleep(1);
// }

export default function () {

  const res = http.get('http://host.docker.internal:8080');

  check(res, { 'status was 200': (r) => r.status == 200 });

  sleep(1);

}

