<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');

	$connection = mysqli_connect('localhost','root','','project_rfid_based_student_attendance');

	$student_id = $_GET['student_id'];

	$query		= "SELECT * FROM logs WHERE student_id = '$student_id' ORDER BY id DESC";
	$query_run	= mysqli_query($connection, $query);
	$r = array();
	if($query_run){
		if(mysqli_num_rows($query_run) > 0){
			while($row = mysqli_fetch_assoc($query_run)){
				$r[] = $row;
			}
			$query     = "UPDATE logs SET is_new_entry = '0' WHERE student_id = '$student_id'";
			$query_run = mysqli_query($connection, $query);
			if($query_run){
				$response['success'] = true;
				$response['message'] = 'data found.';
				$response['logs']	 = $r;
			}else{
				$response['success'] = false;
				$response['message'] = 'Error occured while updating status.';
			}
		}else{
			$response['success'] = false;
			$response['message'] = 'No entry found.';
		}
	}else{
		$response['success'] = false;
		$response['message'] = 'Unknown error occured.';
	}

	echo json_encode($response);
	mysqli_close($connection);
?>