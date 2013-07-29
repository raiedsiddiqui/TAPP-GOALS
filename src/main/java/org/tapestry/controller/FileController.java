package org.tapestry.controller;

import java.io.IOException;
import java.util.Map;

import org.springframework.core.io.ClassPathResource;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.springframework.stereotype.Controller;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.tapestry.dao.SurveyTemplateDao;
import org.tapestry.dao.PictureDao;
import org.tapestry.objects.SurveyTemplate;
import org.yaml.snakeyaml.Yaml;

@Controller
public class FileController extends MultiActionController{
	
	private ClassPathResource dbConfigFile;
	private Map<String, String> config;
	private Yaml yaml;
	
	private SurveyTemplateDao surveyTemplateDao;
	private PictureDao pictureDao;
	
	/**
   	 * Reads the file /WEB-INF/classes/db.yaml and gets the values contained therein
   	 */
   	@PostConstruct
   	public void readDatabaseConfig(){
   		String DB = "";
   		String UN = "";
   		String PW = "";
		try{
			dbConfigFile = new ClassPathResource("tapestry.yaml");
			yaml = new Yaml();
			config = (Map<String, String>) yaml.load(dbConfigFile.getInputStream());
			DB = config.get("url");
			UN = config.get("username");
			PW = config.get("password");
		} catch (IOException e) {
			System.out.println("Error reading from config file");
			System.out.println(e.toString());
		}
		surveyTemplateDao = new SurveyTemplateDao(DB, UN, PW);
		pictureDao = new PictureDao(DB, UN, PW);
   	}
   	
   	@RequestMapping(value = "/upload_survey_template", method=RequestMethod.POST)
	public String addSurveyTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception{
   		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
   		MultipartFile multipartFile = multipartRequest.getFile("file");
   		
		//Add a new survey template
		SurveyTemplate st = new SurveyTemplate();
		st.setTitle(request.getParameter("title"));
		st.setType(request.getParameter("type"));
		st.setContents(multipartFile.getBytes());
		surveyTemplateDao.uploadSurveyTemplate(st);
		
		return "redirect:/manage_survey_templates";
	}
   	
   	@RequestMapping(value="/delete_survey_template/{surveyID}", method=RequestMethod.GET)
   	public String deleteSurveyTemplate(@PathVariable("surveyID") int id){
   		surveyTemplateDao.deleteSurveyTemplate(id);
   		return "redirect:/manage_survey_templates";
   	}
   	
	@RequestMapping(value="/upload_picture_to_profile", method=RequestMethod.POST)
	public String uploadPicture(MultipartHttpServletRequest request){
		//MultipartFile pic = request.getParameter("pic");
		MultipartFile pic = request.getFile("pic");
		System.out.println("Uploaded: " + pic);
		pictureDao.uploadPicture(pic, 1, true); //Change this
		return "redirect:/profile";
	}
}