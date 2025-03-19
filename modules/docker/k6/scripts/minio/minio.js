import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 100 }, // below normal load
    { duration: '1m', target: 100 },
    //{ duration: '2m', target: 200 }, // normal load
    //{ duration: '5m', target: 200 },
    //{ duration: '2m', target: 300 }, // around the breaking point
    //{ duration: '5m', target: 300 },
    //{ duration: '2m', target: 400 }, // beyond the breaking point
    //{ duration: '5m', target: 400 },
    //{ duration: '10m', target: 0 }, // scale down. Recovery stage.
  ],
};

export default function () {
  //const BASE_URL = 'http://172.17.0.3'; // make sure this is not production
  const BASE_URL = 'https://store.$domain_pro_ba'; // make sure this is not production

  const responses = http.batch([
    ['GET', `${BASE_URL}/repo-raw/1.png`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/repo-raw/2.png`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/repo-raw/3.png`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/repo-raw/4.jpg`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/repo-raw/5.jpg`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/repo-raw/6.png`, null, { tags: { name: 'PublicCrocs' } }],
    //['GET', `${BASE_URL}/repo-raw/7.jpg`, null, { tags: { name: 'PublicCrocs' } }],
    //['GET', `${BASE_URL}/repo-raw/8.jpg`, null, { tags: { name: 'PublicCrocs' } }],
  ]);

  sleep(1);
}


