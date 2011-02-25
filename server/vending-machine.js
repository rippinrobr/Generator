var express = require('express'), 
    app = express.createServer();
app.use(express.bodyDecoder());

function create_time_stamp_string() {
  var date_time = new Date(); 
  var month = date_time.getMonth() + 1;
      month = (month < 10 ) ? "0"+month : month;
  var day = date_time.getDate();
      day = (day < 10 ) ? "0"+day : day;
  var hour = date_time.getHours() + 1;
      hour = (hour < 10 ) ? "0"+ hour : hour;
  var minutes = date_time.getMinutes() + 1;
      minutes = (minutes < 10 ) ? "0" + minutes : minutes;
  var seconds = date_time.getSeconds() + 1;
      seconds = (seconds < 10 ) ? "0"+ seconds : seconds;

  return date_time.getFullYear() + "" + month + "" + day + "" + hour + "" + minutes + "" + seconds;
}
app.get("/", function(req, res) {
  res.header("Content-type", "text/html");
  res.send( "<html><head><title>Rob's Code Vending Machine</title></head><body><h2>Rob's Code Vending Machine</h2></body></html>" );
});

app.post('/generate', function(req, res) {
  var time_stamp = create_time_stamp_string();

  res.send("url: " + req.body.source_url + "<br/>Model Class Name: " + req.body.model_class_name + "<br/>language: " + req.body.language + "Date Time: " + time_stamp);
 
});
app.listen(3001);

console.log("listening on port 3001");
