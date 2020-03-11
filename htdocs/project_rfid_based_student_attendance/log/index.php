<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');

	$connection	  = mysqli_connect('localhost','root','','project_rfid_based_student_attendance');
	date_default_timezone_set("Asia/Calcutta");		//India time (GMT+5:30)
	$current_time = date('Y-m-d h:i:s');			//current time
	$student_id	  = $_GET['student_id'];
	$in_out		  = $_GET['in_out'];				// in = 1,  out = 0
	$bus_school	  = $_GET['bus_school'];			// bus = 1, school = 0
	$is_new_entry	  = 1;								//for new entry = 1, it will notify app, then manualy change it to 0 from app side request

	$query		= "INSERT INTO logs (student_id, log_time, in_out, bus_school, is_new_entry) VALUES ('$student_id', '$current_time', '$in_out', '$bus_school', '$is_new_entry')";
	$query_run	= mysqli_query($connection, $query);

	if($query_run){
		$response['success'] = true;
		$response['message'] = 'Entry log successful.';
	}else{
		$response['success'] = false;
		$response['message'] = 'Unknown error occured.';
	}

	echo json_encode($response);
	mysqli_close($connection);
?>