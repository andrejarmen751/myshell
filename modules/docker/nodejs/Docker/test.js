const http = require('http');
const assert  = require("assert");

let BASE_URL = "http://localhost:8020";


  /**
   * Test 1 : Hit BASE_URL and assert response statusCode to be  === 200
   * 
   * @path {BASE_URL}
   * @return expect : {200}
   */
http.get(BASE_URL, (response) => {
      console.log("Response: " + response.statusCode);
      assert(response.statusCode === 200);
    });

  /**
   * Test 2 : Hit `/health` endpoint and assert response statusCode to be  === 200
   * 
   * @path {BASE_URL}/health
   * @return status : {200}
   */
http.get(BASE_URL+'/health', (response) => {
      console.log("Response: " + response.statusCode);
      assert(response.statusCode === 200);
    });


  /**
   * Test 3 : Hit random endpoint `/thisIsNotAValidEndpoint` and assert response statusCode to be  === 404
   * 
   * @path {BASE_URL}/thisIsNotAValidEndpoint
   * @return status : {404}
   */
http.get(BASE_URL+'/thisIsNotAValidEndpoint', (response) => {
      console.log("Response: " + response.statusCode);
      assert(response.statusCode === 404);
    });