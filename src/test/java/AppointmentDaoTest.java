package org.tapestry.tests;

import org.tapestry.dao.AppointmentDao;
import org.tapestry.objects.Appointment;
import java.sql.SQLException;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import static org.junit.Assert.*;
import java.util.ArrayList;

/**
* This class tests the PatientDao to see if an object can be created,
* edited, saved, and retrieved.
*/
public class AppointmentDaoTest{

	private final String DB = "jdbc:mysql://localhost/survey_app";
	private final String UN = "root";
	private final String PW = "root";

	@Test
	public void testGetAllAppointments(){
		AppointmentDao dao = new AppointmentDao(DB, UN, PW);
		assertNotNull("DAO is null", dao);
		ArrayList<Appointment> appts = dao.getAllAppointmentsForVolunteer(2);
		assertNotNull("Query returned null", appts);
		for (Appointment a : appts){
			assertNotNull("Volunteer is null", a.getVolunteer());
			assertNotNull("Patient is null", a.getPatient());
			assertNotNull("Date is null", a.getDate());
			assertNotNull("Time is null", a.getTime());
		}
	}
	
	@Test
	public void testGetAllForToday(){
		AppointmentDao dao = new AppointmentDao(DB, UN, PW);
		assertNotNull("DAO is null", dao);
		ArrayList<Appointment> appts = dao.getAllAppointmentsForVolunteerForToday(2);
		assertNotNull("Query returned null", appts);
		for (Appointment a : appts){
			assertNotNull("Volunteer is null", a.getVolunteer());
			assertNotNull("Patient is null", a.getPatient());
			assertNotNull("Date is null", a.getDate());
			assertNotNull("Time is null", a.getTime());
		}
	}


}
