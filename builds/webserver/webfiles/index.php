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

$stmt = $conn->prepare("SELECT fullname,feedback FROM feedback");
$stmt->execute();
$stmt->store_result();

$HTML = <<<THEEND
<!DOCTYPE html>
<html>
<head>
<title>wm00i - client feedback opportunity</title>
</head>
<body>
<h3>You are invited to provide constructive feedback</h3>
<form action="action.php" method="post">
  Username<br>
  <input type="text" name="fullname" value="">
  <br>
  feedback<br>
  <input type="text" name="feedback" value="">
  <br><br>
  <input type="submit" value="Submit">
</form> 

<p>Use the "Submit" button above to add your feedback to the guest book.</p>
<table style="border:1px solid black">
<tr>
<th>User</th>
<th>feedback</th>
</tr>
THEEND;
print $HTML;

$stmt->bind_result($cuser,$cfeedback);
while ($stmt->fetch()) {
	print "<tr>";
	print "<td>";
	print $cuser;
	print "</td>";
	print "<td>";
	print $cfeedback;
	print "</td>";
	print "</tr>";
}
$HTML = <<<THEEND
</table>
</body>
</html>
THEEND;
print $HTML;

$stmt->close();
$conn->close();


?>
