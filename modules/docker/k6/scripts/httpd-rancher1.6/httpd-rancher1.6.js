import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '3m', target: 100 }, // below normal load
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

export default function () {
  //const BASE_URL = 'http://172.17.0.3'; // make sure this is not production
  const BASE_URL = 'https://httpd.$domain_stg_ba'; // make sure this is not production

  const responses = http.batch([
    ['GET', `${BASE_URL}/1.png`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/2.png`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/3.png`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/4.jpg`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/5.jpg`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/6.png`, null, { tags: { name: 'PublicCrocs' } }],
    //['GET', `${BASE_URL}/7.jpg`, null, { tags: { name: 'PublicCrocs' } }],
    //['GET', `${BASE_URL}/8.jpg`, null, { tags: { name: 'PublicCrocs' } }],
  ]);

  sleep(1);
}


