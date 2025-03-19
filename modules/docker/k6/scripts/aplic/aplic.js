import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // below normal load
    { duration: '5m', target: 100 },
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
  const BASE_URL = 'http://$domain_ba_aplic'; // make sure this is not production

  const responses = http.batch([
    ['GET', `${BASE_URL}/departaments/Informatica/Segur01.nsf/xsp/.ibmmodres/domino/OpenAttachment/departaments/Informatica/Segur01.nsf/4B4D663F2463B917C12580DC002D0EC0/Body/doc%20web%20incidencias%20mbi.v3.pdf`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/departaments/Informatica/Segur01.nsf/xsp/.ibmmodres/domino/OpenAttachment/departaments/Informatica/Segur01.nsf/959624B092DFBEECC12580E3003AA2DF/Body/lnvgy_fod_0001_8869J311Y9K_anyos_noarch.key`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/departaments/Informatica/Segur01.nsf/xsp/.ibmmodres/domino/OpenAttachment/departaments/Informatica/Segur01.nsf/959624B092DFBEECC12580E3003AA2DF/Body/lnvgy_fod_0001_8869J311YA6_anyos_noarch.key`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/departaments/Informatica/Segur01.nsf/xsp/.ibmmodres/domino/OpenAttachment/departaments/Informatica/Segur01.nsf/959624B092DFBEECC12580E3003AA2DF/Body/lnvgy_fod_0001_8869J311YA9_anyos_noarch.key`, null, { tags: { name: 'PublicCrocs' } }],
    ['GET', `${BASE_URL}/departaments/Informatica/Segur01.nsf/xsp/.ibmmodres/domino/OpenAttachment/departaments/Informatica/Segur01.nsf/E18FD095EE09D072C12581F7003DC744/Body/estructura%2busuarisbasics.ldif`, null, { tags: { name: 'PublicCrocs' } }],
  ]);

  sleep(1);
}


