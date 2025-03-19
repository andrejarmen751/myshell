import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 50 }, // below normal load
    //{ duration: '2m', target: 100 },
    //{ duration: '5m', target: 0 }, // scale down. Recovery stage.
  ],
};

export default function () {
  //const BASE_URL = 'http://172.17.0.3'; // make sure this is not production
  const BASE_URL = 'http://snapt.$domain_intra_ba'; // make sure this is not production

  const responses = http.batch([
    ['GET', `${BASE_URL}/snaptHA/liveMonitor`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/snaptHA/status`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/snaptHA/status`, null, { tags: { name: 'PublicCrocs' } }],
  ]);

  sleep(1);
}


