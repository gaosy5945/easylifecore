package com.amarsoft.app.oci.instance.mail;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.internet.MimeMessage;

import com.amarsoft.app.oci.Tools;
import com.amarsoft.app.oci.exception.DataFormatException;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.app.oci.instance.MailInstance;
import com.amarsoft.are.ARE;

public class EmailReceiver {

	private String hostName;
	
	private String username; 
	
	private String password; 
	
	private String saveAttachPath; 
	//所有的邮件
	private Message[] allMessage; 
	//未读邮件
	private ArrayList<EmailRecBean> unseenMessage = new ArrayList<EmailRecBean>();
	
	
	public EmailReceiver(Map<String, String> reqParam) throws OCIException{
		init(reqParam);
	}

	/**
	 * 【读取新邮件】
	 * @param reqParam
	 * @return
	 */
	public List<EmailRecBean> readNewMail() {
//		try{
//			for(EmailRecBean eMail : unseenMessage){
//				eMail.setSeen();
//			}
//		}catch(Exception e){
//			ExceptionFactory.printErrorInfo(e);
//		}
		return unseenMessage;
	}
	
	/**
	 * 【读取所有邮件】
	 * @param reqParam
	 * @return
	 */
	public List<EmailRecBean> readAllMail() {
		ArrayList<EmailRecBean> allMessages = new ArrayList<EmailRecBean>();
		for(Message msg: allMessage)
			allMessages.add(new EmailRecBean((MimeMessage)msg));
		return allMessages;
	}
	
	private void init(Map<String, String> reqParam) throws OCIException {
		try{
			if(reqParam.get("hostName") == null){
				hostName = MailInstance.hostName;
			}else{
				hostName = reqParam.get("hostName");
			}
			if(reqParam.get("username") == null){
				username = MailInstance.username;
			}else{
				username = reqParam.get("username");
			}
			if(reqParam.get("password") == null){
				password = MailInstance.password;
			}else{
				password = reqParam.get("password");
			}
			if(reqParam.get("saveAttachPath") != null){
				saveAttachPath = reqParam.get("saveAttachPath");
			}
			Properties props = new Properties();
			Session session = Session.getDefaultInstance(props, null);
			Store store = session.getStore("imap");
			ARE.getLog().debug("==============connect to Mail Server start ============[" + hostName + "]  [" + username +"] [" + password +"]");
			store.connect(hostName, username, password);
			ARE.getLog().debug("==============connect to Mail Server end ============");

			Folder folder = store.getFolder("INBOX");
			folder.open(Folder.READ_WRITE);
			ARE.getLog().debug("总个数：" + folder.getMessageCount());
			ARE.getLog().debug("未读个数：" + folder.getUnreadMessageCount());
			allMessage = folder.getMessages();
			for(Message msg : allMessage){
				EmailRecBean eMail = new EmailRecBean((MimeMessage)msg);
				eMail.setAttachPath(saveAttachPath);
				if(eMail.isNew()){
					ARE.getLog().debug("===============新邮件===============" + eMail.getSubject());
					unseenMessage.add(eMail);
				}
					
			}
			
			
		}catch(Exception e){
			ExceptionFactory.parse(e, "邮件读取出错");
		}
			
	}
	
	public static void main(String args[]) throws OCIException{
		Map<String, String> reqParam = new HashMap<String, String>();
		reqParam.put("username", "fengjiang377");
		reqParam.put("password", "123");
		EmailReceiver er = new EmailReceiver(reqParam);
	}
}
