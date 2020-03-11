<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');
    
	$connection = mysqli_connect('localhost','root','','project_rfid_based_student_attendance');

	$username 	= $_GET['username'];
	$password 	= $_GET['password'];

	$query		= "SELECT * FROM admin WHERE username = '$username' AND password = '$password'";
	$query_run	= mysqli_query($connection, $query);

	if($query_run){
		if(mysqli_num_rows($query_run) > 0){
			$r = array();
			while ($row = mysqli_fetch_assoc($query_run)) {
				$r[] = $row;
			}
			$response['success'] = true;
			$response['message'] = 'Login successful.';
			$response['data']    = $r;

		}else{
			$response['success'] = false;
			$response['message'] = 'Account not found.';
		}
	}else{
		$response['success'] = false;
		$response['message'] = 'Unknown error occured.';
	}
	echo json_encode($response);
	mysqli_close($connection);
?>