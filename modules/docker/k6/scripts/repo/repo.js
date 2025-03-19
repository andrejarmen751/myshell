import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 100 }, // below normal load
    { duration: '1m', target: 100 },
    { duration: '2m', target: 0 }, // scale down. Recovery stage.
  ],
};

export default function () {
  //const BASE_URL = 'http://172.17.0.3'; // make sure this is not production
  const BASE_URL = 'http://repo.$domain_stg_ba'; // make sure this is not production

  const responses = http.batch([
    ['GET', `${BASE_URL}/tomcat/5/tomcat.bash`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/tomcat/6/tomcat.bash`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/tomcat/7/tomcat.bash`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/tomcat/8/tomcat.bash`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/tomcat/9-0-39/tomcat.bash`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/tomcat/9/tomcat.bash`, null, { tags: { name: 'PublicCrocs' } }],
  ]);

  sleep(1);
}


