package org.tapestry.controller;

import org.springframework.stereotype.Controller;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.tapestry.dao.UserDao;
import org.tapestry.dao.PatientDao;
import org.tapestry.dao.AppointmentDao;
import org.tapestry.dao.MessageDao;
import org.tapestry.dao.SurveyResultDao;
import org.tapestry.dao.PictureDao;
import org.tapestry.objects.SurveyResult;
import org.tapestry.dao.ActivityDao;
import org.tapestry.objects.User;
import org.tapestry.objects.Patient;
import org.tapestry.objects.Appointment;
import org.tapestry.objects.Message;
import org.tapestry.objects.Activity;
import org.tapestry.objects.Picture;
import java.util.ArrayList;
import org.yaml.snakeyaml.Yaml;
import java.io.IOException;
import java.util.Map;
import org.springframework.core.io.ClassPathResource;
import javax.annotation.PostConstruct;
import java.util.Properties;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Transport;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


/**
* Main controller class
* This class is responsible for interpreting URLs and returning the appropriate pages.
* It is the 'brain' of the application. Each function is tagged with @RequestMapping and
* one of either RequestMethod.GET or RequestMethod.POST, which determines which requests
* the function will be triggered in response to.
* The function returns a string, which is the name of a web page to render. For example,
* the login() function returns "login" when an HTTP request like "HTTP 1.1 GET /login"
* is received. The application then loads the page "login.jsp" (the extension is added
* automatically).
*/
@Controller
public class TapestryController{
	
	private ClassPathResource dbConfigFile;
	private Map<String, String> config;
	private Yaml yaml;
		
	private UserDao userDao;
   	private PatientDao patientDao;
   	private AppointmentDao appointmentDao;
   	private MessageDao messageDao;
   	private PictureDao pictureDao;
   	private SurveyResultDao surveyResultDao;
   	private ActivityDao activityDao;
   	
   	//Mail-related settings;
   	private Properties props;
   	private String mailAddress = "";
   	private Session session;
   	
   	/**
   	 * Reads the file /WEB-INF/classes/db.yaml and gets the values contained therein
   	 */
   	@PostConstruct
   	public void readConfig(){
   		String database = "";
   		String dbUsername = "";
   		String dbPassword = "";
   		String mailHost = "";
   		String mailUser = "";
   		String mailPassword = "";
   		String mailPort = "";
   		String useTLS = "";
   		String useAuth = "";
		try{
			dbConfigFile = new ClassPathResource("tapestry.yaml");
			yaml = new Yaml();
			config = (Map<String, String>) yaml.load(dbConfigFile.getInputStream());
			database = config.get("url");
			dbUsername = config.get("username");
			dbPassword = config.get("password");
			mailHost = config.get("mailHost");
			mailUser = config.get("mailUser");
			mailPassword = config.get("mailPassword");
			mailAddress = config.get("mailAddress");
			mailPort = config.get("mailPort");
			useTLS = config.get("mailUsesTLS");
			useAuth = config.get("mailRequiresAuth");
		} catch (IOException e) {
			System.out.println("Error reading from config file");
			System.out.println(e.toString());
		}
		
		//Create the DAOs
		userDao = new UserDao(database, dbUsername, dbPassword);
		patientDao = new PatientDao(database, dbUsername, dbPassword);
		appointmentDao = new AppointmentDao(database, dbUsername, dbPassword);
		messageDao = new MessageDao(database, dbUsername, dbPassword);
		pictureDao = new PictureDao(database, dbUsername, dbPassword);
		surveyResultDao = new SurveyResultDao(database, dbUsername, dbPassword);
		activityDao = new ActivityDao(database, dbUsername, dbPassword);
		
		//Mail-related settings
		final String username = mailUser;
		final String password = mailPassword;
		props = System.getProperties();
		session = Session.getDefaultInstance(props, 
				 new javax.mail.Authenticator() {
					protected PasswordAuthentication getPasswordAuthentication() {
						return new PasswordAuthentication(username, password);
					}
		  		});
		props.setProperty("mail.smtp.host", mailHost);
		props.setProperty("mail.smtp.socketFactory.port", mailPort);
		props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		props.setProperty("mail.smtp.auth", useAuth);
		props.setProperty("mail.smtp.starttls.enable", useTLS);
		props.setProperty("mail.user", mailUser);
		props.setProperty("mail.password", mailPassword);
   	}
   	
   	//Everything below this point is a RequestMapping

	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String login(@RequestParam(value="usernameChanged", required=false) Boolean usernameChanged, ModelMap model){
		if (usernameChanged != null)
			model.addAttribute("usernameChanged", usernameChanged);
		return "login";
	}
	
	@RequestMapping(value="/loginsuccess", method=RequestMethod.GET)
	public String loginSuccess(SecurityContextHolderAwareRequestWrapper request){
		String username = request.getUserPrincipal().getName();
		User u = userDao.getUserByUsername(username);
		if (request.isUserInRole("ROLE_USER")){
			activityDao.logActivity(u.getName() + " logged in", u.getUserID());
		}
		return "redirect:/";
	}

	@RequestMapping(value="/", method=RequestMethod.GET)
	//Note that messageSent is Boolean, not boolean, to allow it to be null
	public String welcome(@RequestParam(value="success", required=false) Boolean messageSent, SecurityContextHolderAwareRequestWrapper request, ModelMap model){
		if (request.isUserInRole("ROLE_USER")){
			String username = request.getUserPrincipal().getName();
			User u = userDao.getUserByUsername(username);
			ArrayList<Patient> patientsForUser = patientDao.getPatientsForVolunteer(u.getUserID());
			ArrayList<Appointment> appointmentsForToday = appointmentDao.getAllAppointmentsForVolunteerForToday(u.getUserID());
			ArrayList<Appointment> allAppointments = appointmentDao.getAllAppointmentsForVolunteer(u.getUserID());
			ArrayList<Activity> activityLog = activityDao.getLastNActivitiesForVolunteer(u.getUserID(), 5); //Cap recent activities at 5
			ArrayList<Message> announcements = messageDao.getAnnouncementsForUser(u.getUserID());
			//ArrayList<Activity> activityLog = activityDao.getAllActivitiesForVolunteer(u.getUserID());
			model.addAttribute("name", u.getName());
			model.addAttribute("patients", patientsForUser);
			model.addAttribute("appointments_today", appointmentsForToday);
			model.addAttribute("appointments_all", allAppointments);;
			int unreadMessages = messageDao.countUnreadMessagesForRecipient(u.getUserID());
			model.addAttribute("unread", unreadMessages);
			model.addAttribute("activities", activityLog);
			model.addAttribute("announcements", announcements);
			
			return "volunteer/index";
		}
		else if (request.isUserInRole("ROLE_ADMIN")){
			String name = request.getUserPrincipal().getName();
			model.addAttribute("name", name);
			ArrayList<User> volunteers = userDao.getAllUsersWithRole("ROLE_USER");
			model.addAttribute("volunteers", volunteers);
			if (messageSent != null)
				model.addAttribute("success", messageSent);
			return "admin/index";
		}
		else{ //This should not happen, but catch any unforseen behavior
			return "redirect:/login";
		}
	}

	@RequestMapping(value="/loginfailed", method=RequestMethod.GET)
	public String failed(ModelMap model){
		model.addAttribute("error", "true");
		return "login";
	}

	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(SecurityContextHolderAwareRequestWrapper request){
		String username = request.getUserPrincipal().getName();
		User currentUser = userDao.getUserByUsername(username);
		activityDao.logActivity(currentUser.getName() + " logged out", currentUser.getUserID());
		return "redirect:/j_spring_security_logout";
	}
	
	@RequestMapping(value="/manage_users", method=RequestMethod.GET)
	public String manageUsers(ModelMap model){
		ArrayList<User> userList = userDao.getAllUsers();
		model.addAttribute("users", userList);
		model.addAttribute("active", userDao.countActiveUsers());
		model.addAttribute("total", userDao.countAllUsers());
		return "admin/manage_users";
	}
	@RequestMapping(value="/manage_patients", method=RequestMethod.GET)
	public String managePatients(ModelMap model){
		ArrayList<User> volunteers = userDao.getAllUsersWithRole("ROLE_USER");
		model.addAttribute("volunteers", volunteers);
	        ArrayList<Patient> patientList = patientDao.getAllPatients();
                model.addAttribute("patients", patientList);
		return "admin/manage_patients";
	}

	@RequestMapping(value="/add_user", method=RequestMethod.POST)
	public String addUser(SecurityContextHolderAwareRequestWrapper request){
		//Add a new user
		User u = new User();
		u.setName(request.getParameter("name"));
		u.setUsername(request.getParameter("username"));
		u.setRole(request.getParameter("role"));
		
		ShaPasswordEncoder enc = new ShaPasswordEncoder();
		String hashedPassword = enc.encodePassword("password", null); //Default
		
		u.setPassword(hashedPassword);
		u.setEmail(request.getParameter("email"));
		userDao.createUser(u);
		if (mailAddress != null){
			try{
				MimeMessage message = new MimeMessage(session);
				message.setFrom(new InternetAddress(mailAddress));
				message.addRecipient(MimeMessage.RecipientType.TO, new InternetAddress(u.getEmail()));
				message.setSubject("Welcome to Tapestry");
				String msg = "";
				msg += "Thank you for volunteering with Tapestry. Your account has been successfully created.\n";
				msg += "Your username and password are as follows:\n";
				msg += "Username: " + u.getUsername() + "\n";
				msg += "Password: password\n\n";
				msg += "We recommend that you change your password as soon as possible due to security reasons";
				message.setText(msg);
				System.out.println(msg);
				System.out.println("Sending...");
				Transport.send(message);
				System.out.println("Email sent containing credentials to " + u.getEmail());
			} catch (MessagingException e) {
				System.out.println("Error: Could not send email");
				System.out.println(e.toString());
			}
		}
		//Display page again
		return "redirect:/manage_users";
	}

	@RequestMapping(value="/remove_user/{user_id}", method=RequestMethod.GET)
	public String removeUser(@PathVariable("user_id") int id){
		userDao.removeUserWithID(id);
		return "redirect:/manage_users";
	}
	
	@RequestMapping(value="/disable_user/{user_id}", method=RequestMethod.GET)
	public String disableUser(@PathVariable("user_id") int id){
		userDao.disableUserWithID(id);
		return "redirect:/manage_users";
	}

	@RequestMapping(value="/enable_user/{user_id}", method=RequestMethod.GET)
	public String enableUser(@PathVariable("user_id") int id){
		userDao.enableUserWithID(id);
		return "redirect:/manage_users";
	}

	@RequestMapping(value="/add_patient", method=RequestMethod.POST)
	public String addPatient(SecurityContextHolderAwareRequestWrapper request){
		//Add a new patient
		Patient p = new Patient();
		p.setFirstName(request.getParameter("firstname"));
		p.setLastName(request.getParameter("lastname"));
		int v = Integer.parseInt(request.getParameter("volunteer"));
		p.setVolunteer(v);
		p.setColor(request.getParameter("backgroundColor"));
		p.setBirthdate(request.getParameter("birthdate"));
		p.setGender(request.getParameter("gender"));
		p.setWarnings(request.getParameter("warnings"));
		patientDao.createPatient(p);
		return "redirect:/manage_patients";
	}

	@RequestMapping(value="/remove_patient/{patient_id}", method=RequestMethod.GET)
	public String removePatient(@PathVariable("patient_id") int id){
		Patient p = patientDao.getPatientByID(id);
		patientDao.removePatientWithId(id);
		activityDao.logActivity("Removed patient: " + p.getDisplayName(), p.getVolunteer(), p.getPatientID());
		return "redirect:/manage_patients";
	}

	@RequestMapping(value="/patient/{patient_id}", method=RequestMethod.GET)
	public String viewPatient(@PathVariable("patient_id") int id, SecurityContextHolderAwareRequestWrapper request, ModelMap model){
		Patient patient = patientDao.getPatientByID(id);
		//Find the name of the current user
		User u = userDao.getUserByUsername(request.getUserPrincipal().getName());
		String loggedInUser = u.getName();
		//Make sure that the user is actually responsible for the patient in question
		int volunteerForPatient = patient.getVolunteer();
		if (!(u.getUserID() == patient.getVolunteer())){
			model.addAttribute("loggedIn", loggedInUser);
			model.addAttribute("patientOwner", volunteerForPatient);
			return "redirect:/403";
		}
		model.addAttribute("patient", patient);
		int unreadMessages = messageDao.countUnreadMessagesForRecipient(u.getUserID());
		model.addAttribute("unread", unreadMessages);
		ArrayList<SurveyResult> surveyResultList = surveyResultDao.getIncompleteSurveysByPatientID(id);
		model.addAttribute("surveys", surveyResultList);
		ArrayList<Picture> pics = pictureDao.getPicturesForPatient(id);
		model.addAttribute("pictures", pics);
		activityDao.logActivity(u.getName() + " viewing patient: " + patient.getDisplayName(), u.getUserID(), patient.getPatientID());
		return "/patient";
	}
	
	@RequestMapping(value="/profile", method=RequestMethod.GET)
	public String viewProfile(@RequestParam(value="error", required=false) String errorsPresent, SecurityContextHolderAwareRequestWrapper request, ModelMap model){
		User loggedInUser = userDao.getUserByUsername(request.getUserPrincipal().getName());
		model.addAttribute("vol", loggedInUser);
		int unreadMessages = messageDao.countUnreadMessagesForRecipient(loggedInUser.getUserID());
		model.addAttribute("unread", unreadMessages);
		if (errorsPresent != null)
			model.addAttribute("errors", errorsPresent);
		ArrayList<Picture> pics = pictureDao.getPicturesForUser(loggedInUser.getUserID());
		model.addAttribute("pictures", pics);
		return "/volunteer/profile";
	}
	
	@RequestMapping(value="/inbox", method=RequestMethod.GET)
	public String viewInbox(SecurityContextHolderAwareRequestWrapper request, ModelMap model){
		User loggedInUser = userDao.getUserByUsername(request.getUserPrincipal().getName());
		ArrayList<Message> messages = messageDao.getAllMessagesForRecipient(loggedInUser.getUserID());
		model.addAttribute("messages", messages);
		int unreadMessages = messageDao.countUnreadMessagesForRecipient(loggedInUser.getUserID());
		model.addAttribute("unread", unreadMessages);
		return "/volunteer/inbox";
	}
	
	@RequestMapping(value="/view_message/{msgID}", method=RequestMethod.GET)
	public String viewMessage(@PathVariable("msgID") int id, SecurityContextHolderAwareRequestWrapper request, ModelMap model){
		User loggedInUser = userDao.getUserByUsername(request.getUserPrincipal().getName());
		Message m = messageDao.getMessageByID(id);
		if (!(m.getRecipient() == loggedInUser.getUserID()))
			return "redirect:/403";
		if (!(m.isRead()))
			messageDao.markAsRead(id);
		int unreadMessages = messageDao.countUnreadMessagesForRecipient(loggedInUser.getUserID());
		model.addAttribute("unread", unreadMessages);
		model.addAttribute("message", m);
		return "/volunteer/view_message";
	}
	
	@RequestMapping(value="/dismiss/{announcement}", method=RequestMethod.GET)
	public String dismissAnnouncement(@PathVariable("announcement") int id, SecurityContextHolderAwareRequestWrapper request){
		User loggedInUser = userDao.getUserByUsername(request.getUserPrincipal().getName());
		Message m = messageDao.getMessageByID(id);
		if (!(m.getRecipient() == loggedInUser.getUserID()))
			return "redirect:/403";
		messageDao.markAsRead(id);
		return "redirect:/";
	}

	@RequestMapping(value="/send_message", method=RequestMethod.POST)
	public String sendMessage(SecurityContextHolderAwareRequestWrapper request, ModelMap model){
		User loggedInUser = userDao.getUserByUsername(request.getUserPrincipal().getName());
		Message m = new Message();
		m.setSender(loggedInUser.getName());
		m.setText(request.getParameter("msgBody"));
		if (request.getParameter("isAnnouncement") != null && request.getParameter("isAnnouncement").equals("true")){ //Sound to all volunteers
			ArrayList<User> volunteers = userDao.getAllUsersWithRole("ROLE_USER");
			for (User u: volunteers){
				m.setSubject("ANNOUNCEMENT: " + request.getParameter("msgSubject"));
				m.setRecipient(u.getUserID());
				
				User recipient = userDao.getUserByID(u.getUserID());
				
				if (mailAddress != null){
					try{
						MimeMessage message = new MimeMessage(session);
						message.setFrom(new InternetAddress(mailAddress));
						message.addRecipient(MimeMessage.RecipientType.TO, new InternetAddress(recipient.getEmail()));
						message.setSubject("Tapestry: New message notification");
						String msg = "You have received an announcement. To view it, log in to Tapestry.";
						message.setText(msg);
						System.out.println(msg);
						System.out.println("Sending...");
						Transport.send(message);
						System.out.println("Email sent notifying " + recipient.getEmail());
					} catch (MessagingException e) {
						System.out.println("Error: Could not send email");
						System.out.println(e.toString());
					}
				}
				messageDao.sendMessage(m);
			}
		}
		else{ //Send to one person
			int recipientID = Integer.parseInt(request.getParameter("recipient"));
			m.setRecipient(recipientID);
			m.setSubject(request.getParameter("msgSubject"));
			messageDao.sendMessage(m);

			
			User recipient = userDao.getUserByID(recipientID);
			
			if (mailAddress != null){
				try{
					MimeMessage message = new MimeMessage(session);
					message.setFrom(new InternetAddress(mailAddress));
					message.addRecipient(MimeMessage.RecipientType.TO, new InternetAddress(recipient.getEmail()));
					message.setSubject("Tapestry: New message notification");
					String msg = "You have received a message. To review it, log into Tapestry and open your inbox.";
					message.setText(msg);
					System.out.println(msg);
					System.out.println("Sending...");
					Transport.send(message);
					System.out.println("Email sent notifying " + recipient.getEmail());
				} catch (MessagingException e) {
					System.out.println("Error: Could not send email");
					System.out.println(e.toString());
				}
			}
		}

		return "redirect:/?success=true";
	}
	
	@RequestMapping(value="/delete_message/{msgID}", method=RequestMethod.GET)
	public String deleteMessage(@PathVariable("msgID") int id, ModelMap model){
		messageDao.deleteMessage(id);
		return "redirect:/inbox";
	}

	//Error pages
	@RequestMapping(value="/403", method=RequestMethod.GET)
	public String forbiddenError(){
		return "error-forbidden";
	}
	
	@RequestMapping(value="/update_user", method=RequestMethod.POST)
	public String updateUser(SecurityContextHolderAwareRequestWrapper request){
		String currentUsername = request.getUserPrincipal().getName();
		User loggedInUser = userDao.getUserByUsername(currentUsername);
		User u = new User();
		u.setUserID(loggedInUser.getUserID());
		u.setUsername(request.getParameter("volUsername"));
		u.setName(request.getParameter("volName"));
		u.setEmail(request.getParameter("volEmail"));
		userDao.modifyUser(u);
		if (!(currentUsername.equals(u.getUsername())))
			return "redirect:/login?usernameChanged=true";
		else
			return "redirect:/profile";
	}
	
	@RequestMapping(value="/change_password", method=RequestMethod.POST)
	public String changePassword(SecurityContextHolderAwareRequestWrapper request){
		String currentUsername = request.getUserPrincipal().getName();
		User loggedInUser = userDao.getUserByUsername(currentUsername);
		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");
		if (!newPassword.equals(confirmPassword)){
			return "redirect:/profile?error=confirm";
		}
		if (!userDao.userHasPassword(loggedInUser.getUserID(), currentPassword)){
			return "redirect:/profile?error=current";
		}
		ShaPasswordEncoder enc = new ShaPasswordEncoder();
		String hashedPassword = enc.encodePassword(newPassword, null);
		userDao.setPasswordForUser(loggedInUser.getUserID(), hashedPassword);
		activityDao.logActivity("Changed password", loggedInUser.getUserID());
		return "redirect:/profile";
	}
	
	@RequestMapping(value="/remove_picture/{id}", method=RequestMethod.GET)
	public String removePicture(@PathVariable("id") int pictureID){
		pictureDao.removePicture(pictureID);
		return "redirect:/profile";
	}
	
	@RequestMapping(value="/edit_patient/{id}", method=RequestMethod.GET)
	public String editPatientForm(@PathVariable("id") int patientID, ModelMap model){
		Patient p = patientDao.getPatientByID(patientID);
		model.addAttribute("patient", p);
		ArrayList<User> volunteers = userDao.getAllUsersWithRole("ROLE_USER");
		model.addAttribute("volunteers", volunteers);
		return "/admin/edit_patient"; //Why this one requires a slash when none of the others do, I do not know.
	}
	
	@RequestMapping(value="/submit_edit_patient/{id}", method=RequestMethod.POST)
	public String modifyPatient(@PathVariable("id") int patientID, SecurityContextHolderAwareRequestWrapper request){
		Patient p = new Patient();
		p.setPatientID(patientID);
		p.setFirstName(request.getParameter("firstname"));
		p.setLastName(request.getParameter("lastname"));
		int v = Integer.parseInt(request.getParameter("volunteer"));
		p.setVolunteer(v);
		p.setColor(request.getParameter("backgroundColor"));
		p.setBirthdate(request.getParameter("birthdate"));
		p.setGender(request.getParameter("gender"));
		p.setWarnings(request.getParameter("warnings"));
		patientDao.updatePatient(p);
		activityDao.logActivity("Modified patient: " + p.getDisplayName(), v);
		return "redirect:/manage_patients";
	}
	
	@RequestMapping(value="/user_logs", method=RequestMethod.GET)
	public String viewUserLogs(SecurityContextHolderAwareRequestWrapper request, ModelMap m){
		ArrayList<Activity> activityLog = activityDao.getAllActivities();
		m.addAttribute("activities", activityLog);
		return "admin/user_logs";
	}
	
	@RequestMapping(value="/user_logs", method=RequestMethod.POST)
	public String viewFilteredUserLogs(SecurityContextHolderAwareRequestWrapper request, ModelMap m){
		ArrayList<Activity> activityLog = new ArrayList<Activity>();
		String name = request.getParameter("name");
		if(name != null) {
			ArrayList<User> u = userDao.getUsersByPartialName(name);
			ArrayList<Integer> userIds = new ArrayList<Integer>();
			for(User user : u) {
				userIds.add(user.getUserID());
			}
			activityLog = activityDao.getAllActivitiesForVolunteers(userIds);
		} else {
			activityLog = activityDao.getAllActivities();
		}
		m.addAttribute("activities", activityLog);
		return "admin/user_logs";
	}
}
