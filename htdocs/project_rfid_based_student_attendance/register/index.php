<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');

	$connection = mysqli_connect('localhost','root','','project_rfid_based_student_attendance');

	$username 	= $_GET['username'];
	$email 		= $_GET['email'];
	$mobile 	= $_GET['mobile'];
	$student_id = $_GET['student_id'];
	$password 	= $_GET['password'];


	$query		= "INSERT INTO admin (username, email, mobile, student_id, password) VALUES ('$username', '$email', '$mobile', '$student_id', '$password')";
	$query_run	= mysqli_query($connection, $query);

	if($query_run){
		$response['success'] = true;
		$response['message'] = 'Register successfuly.';
	}else{
		$response['success'] = false;
		$response['message'] = 'Unknown error occured.';
	}

	echo json_encode($response);
	mysqli_close($connection);
?>