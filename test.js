var axios = require('axios');

async function test_user() {
  const userConfigGet = {
    method: 'get',
    url: 'http://localhost:4000/api/users/1',
    headers: { }
  };
  const userResGet = {
    data: {
      email: "test@test.com",
      id: 1,
      is_active: false,
      username: "test"
    }
  }
  
  const userConfigPost = {
    method: 'post',
    url: 'http://localhost:4000/api/users/?email=test@test.com&username=test',
    headers: { }
  };
  const userResPost = {
    data: {
      email: "test@test.com",
      id:1,
      is_active:false,
      username:"test"
    }
  }
  
  const userConfigPut = {
    method: 'put',
    url: 'http://localhost:4000/api/users/1?email=updated@test.com&username=updated',
    headers: {}
  }
  const userResPut = {
    data: {
      email: "updated@test.com",
      id:1,
      is_active:false,
      username:"updated"
    }
  }
  
  const userConfigDel = {
    method: 'delete',
    url: "http://localhost:4000/api/users/1",
    headers: { }
  }
  const userResDel = {
    response: "deleted"
  }
  console.log("\n\n------- USER UNIT TESTS -------\n\n")
  console.log("------ TESTING POST ------")
  console.log("TRYING TO CREATE NEW USER")
  await axios(userConfigPost)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(userResPost)) {
      throw "results differ: " + JSON.stringify(response.data)
    }else {
      console.log("TEST OK")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "user creation error:\n" + error
    }
  });

  console.log("\n------ TESTING GET ------")
  console.log("TRYING TO LIST USER")
  await axios(userConfigGet)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(userResGet)) {
      throw "results differ: " + JSON.stringify(response.data);
    } else {
      console.log("TEST OK")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "user listing error:\n" + error
    }
  });

  console.log("\n------ TESTING UPDATE ------")
  console.log("TRYING TO EDIT EXISTING USER")
  await axios(userConfigPut)
  .then(function (response) {
    if (response && (JSON.stringify(response.data) != JSON.stringify(userResPut))) {
      throw "results differ: " + JSON.stringify(response.data)
    } else {
      console.log("TEST OK\nGOT:\n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "user update error:\n" + error
    }
  })

  console.log("\n------ TESTING DELETE ------")
  console.log("TRYING TO DELETE USER")
  await axios(userConfigDel)
  .then(function (response) {
    if (response && (JSON.stringify(response.data) != JSON.stringify(userResDel))) {
      throw "results differ: " + JSON.stringify(response.data)
    } else {
      console.log("TEST OK\nGOT:\n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "user delete error:\n" + error
    }
  })
  console.log("\n------- USER UNIT TEST OK -------\n\n")
}

async function test_working_times() {
  const userConfigPost = {
    method: 'post',
    url: 'http://localhost:4000/api/users/?email=test@test.com&username=test',
    headers: { }
  };
  const userResPost = {
    data: {
      email: "test@test.com",
      id:2,
      is_active:false,
      username:"test"
    }
  }

  const wtConfigPost = {
    method: "post",
    url: "http://localhost:4000/api/workingtimes/2?start=2000-01-01 23:00:07&end=2000-01-02 23:00:07", 
    headers: { }
  }
  const wtResPost = {
    success: "Created"
  }

  const wtConfigGet = {
    method: "get",
    url: "http://localhost:4000/api/workingtimes/2",
    headers: { }
  }
  const wtResGet = {
    data: [{
      end : "2000-01-02T23:00:07",
      id: 1,
      start : "2000-01-01T23:00:07",
      user: "2"
    }]
  }

  const wtConfigPut = {
    method: "put",
    url: "http://localhost:4000/api/workingtimes/1?start=2001-02-02 23:00:07&end=2001-02-02 23:00:07",
    headers: { },
  }
  const wtResPut = {
    Response: "Updated",
    end: "2001-02-02 23:00:07",
    id: '1',
    start: "2001-02-02 23:00:07",
  }

  const wtConfigDel = {
    method: "delete",
    url: "http://localhost:4000/api/workingtimes/1",
    headers: { }
  }
  const wtResDel = {
    response: "Deleted"
  }

  await axios(userConfigPost)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(userResPost)) {
      throw "results differ: " + JSON.stringify(response.data)
    }else {
      console.log("USER CREATED")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "user create error:\n" + error
    }
  });

  console.log("\n\n------- WORKING TIMES UNIT TESTS -------\n\n")
  console.log("------ CREATING WT ------")
  console.log("TRYING TO CREATE WT")
  await axios(wtConfigPost)
  .then(function (response) {
    if (response && (JSON.stringify(response.data) != JSON.stringify(wtResPost))) {
      throw "results differ: " + JSON.stringify(response.data)
    } else {
      console.log("TEST OK\nGOT:\n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "wt create error:\n" + error
    }
  })
  console.log("------ GETTING WT ------")
  console.log("TRYING TO LIST WT")
  await axios(wtConfigGet)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(wtResGet)) {
      throw "results differ: " + JSON.stringify(response.data)
    }else {
      console.log("TEST OK")
      console.log("GOT : \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "wt read error:\n" + error
    }
  });
  console.log("------ UPDATING WT ------")
  console.log("TRYING TO UPDATE WT")
  await axios(wtConfigPut)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(wtResPut)) {
      throw "results differ: " + JSON.stringify(response.data)
    } else {
      console.log("WT UPDATED");
      console.log("GOT: \n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response) {
      throw error.response.data.errors;
    } else {
      throw "wt update error:\n" + error
    }
  })
  console.log("------ DELETING WT ------")
  console.log("TRYING TO DELETE WT")
  await axios(wtConfigDel)
  .then(function (response) {
    if (JSON.stringify(response.data) != JSON.stringify(wtResDel))
      throw "results differ: " + JSON.stringify(response.data)
    else {
      console.log("WT DELETED");
      console.log("GOT:\n" + JSON.stringify(response.data))
    }
  })
  .catch(function (error) {
    if (error.response)
      throw error.response.data.errors;
    else
      throw "wt delete error:\n" + error
  })
  console.log("\n------- WORKING TIMES UNIT TEST OK -------\n\n")
}

async function run_test() {
  console.log("--------------------- STARTING TESTS ---------------------")
  try {
    await test_user();
    await test_working_times();
    console.log("--------------------- TESTS ENDED SUCCESSFULLY ---------------------")
  } catch (e) {
    console.log(e)
    console.log("--------------------- TESTS ENDED WITH ERROR ---------------------")
  }
}

run_test();