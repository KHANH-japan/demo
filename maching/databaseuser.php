<?php 
	$severname = "localhost";
	$username  = "root";
	$password  = "";
	$dbname    = "samplemaching";
	$conn = mysqli_connect($severname,$username,$password,$dbname);
	
	if (! $conn){
		die('erro' . $conn->connect_error);
	}
	
	$sql = "SELECT userId FROM user";
	$result = $conn -> query($sql);
	//assoc ( call all data in datasever) 
	$data = mysqli_fetch_assoc($result);
	echo $data["userId"];
	
	$conn->close();
?>