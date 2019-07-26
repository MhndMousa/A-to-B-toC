const express = require('express')
const smartcar = require('smartcar');
const app = express()
const port = 8000

const client = new smartcar.AuthClient({
  clientId: 'a02f2bef-aac3-47a7-b9b5-30e78236a2f7',
  clientSecret: 'e24a0e46-860a-4912-8bb6-dcbf5488be1a',
  redirectUri: 'sca02f2bef-aac3-47a7-b9b5-30e78236a2f7://exchange',
  scope: ['required:read_vehicle_info','control_security', "control_security:unlock", "control_security:lock"],
  testMode: false,
});

let access;





app.get('/exchange', function(req, res) {

  const code = req.query.code;

  // return client.exchangeCode(code)
  //  .then(function(access) {
  //    console.log(access);
  //    accessToken = access["accessToken"]
  //    console.log(accessToken);
  //  })

  return client.exchangeCode(code)
      .then(function(_access) {
        // in a production app you'll want to store this in some kind of persistent storage
        access = _access;
        console.log(access);
        // res.redirect('/vehicle');
      })

});

app.get('/lock', function(req, res) {
  vehicle.lock().then(function(response) {
    console.log(response);
  });
});

app.get('/unlock', function(req, res) {
  vehicle.unlock().then(function(response) {
    console.log(response);
  });
});


app.get(':car/security', function(req, res) {

  const newVehicle = new smartcar.Vehicle(req.params.car, access.accessToken)
  vehicle.lock().then(function(response) {
    console.log(response);
  });

  vehicle.unlock().then(function(response) {
    console.log(response);
  });


});




app.get('/allcars', function(req, res) {

  // smartcar.getVehicleIds(access, {limit: 0, offset: 20})
  //   .then(function(response) {
  //     console.log(response);
  // });

  return smartcar.getVehicleIds(access.accessToken)
    .then(function(data) {
      // the list of vehicle ids
      return data.vehicles;
    })
    .then(async function(vehicleIds) {
      // instantiate the first vehicle in the vehicle id list
      const vehicles = []
      for (var i = 0; i < vehicleIds.length; i++) {
        const v = new smartcar.Vehicle(vehicleIds[i], access.accessToken)
        vehicles.push(await v.info());
      }
      return vehicles
    })
    .then(function(vehicles) {
      console.log(vehicles)
      res.send(vehicles)
    });
})


app.get('/:vehicleId/location', function(req, res) {

  console.log('vehicleId:',req.params.vehicleId);
  const newVehicle = new smartcar.Vehicle(req.params.vehicleId, access.accessToken)
  newVehicle.location().then(function(response) {
    console.log(response);
    // return response;
    res.send(response)
  });

})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))
