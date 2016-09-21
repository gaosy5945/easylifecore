package com.amarsoft.app.oci.instance;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.ARE;
//import com.amarsoft.app.oci.OCIClientFacade;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.OCIReceiver;
import com.amarsoft.app.oci.bean.OCIRequestParam;
import com.amarsoft.app.oci.exception.DataFormatException;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.app.oci.instance.mail.EmailAttachment;
import com.amarsoft.app.oci.instance.mail.EmailRecBean;
import com.amarsoft.app.oci.instance.mail.EmailReceiver;
import com.amarsoft.app.oci.instance.mail.EmailSender;
import com.amarsoft.app.oci.instance.mail.MultiPartEmail;
import com.amarsoft.app.oci.instance.mail.SimpleEmail;

/**
 * ����Mail���ͽӿ���ʵ���շ��ʼ�
 * ����ģʽ
 * @author feng
 * 
 */
public class MailInstance {
	
	public static final String hostName = OCIConfig.getProperty("Mailhostname","10.100.1.95");//MAILSERVER01.HDQ.SPDB.COM");
	public static final String username = OCIConfig.getProperty("Mailusername","zhlsxdfwxtspzy");
	public static final String password = OCIConfig.getProperty("Mailpassword","spdb@2445");	
	public static final String displayName = OCIConfig.getProperty("Maildisplayname","zhlsxdfwxtspzy@spdb.com.cn");
	public static final String LIMIT_ALERT = "���䳬�������С����";
	public static String alertPhoneNos[] = null;//OCIConfig.mailMap.get("alertPhoneNo").split(",");
	private static MailInstance instance;
	private MailInstance() {
		
	}

	public static synchronized MailInstance getInstance() {
		if (instance == null) {
			instance = new MailInstance();
		}
		return instance;
	}
	
	/**************************************************************
	 * ���������ò�����
	 * username;	// �û���
	 * password;	//����
	 * ============================================================
	 * ����ѡ���ò�����
	 * hostName;	//imap�ʼ��������� Ĭ��Ϊ"imap.sohu.com"
	 * saveAttachPath;		//�������غ�Ĵ��Ŀ¼
     * -------------------------------------------------------
     *����ȡδ���ʼ���
	 * @param reqParam ���ò�������
	 * @return EmailRecBean ��װ�õ��ʼ����ض���
	 * @throws Exception 
	 **************************************************************/
	public List<EmailRecBean> readNewMail(Map<String, String> reqParam) throws Exception {
		List<EmailRecBean> eMails = null;
		PreparedStatement prepareStatement = null;
		ResultSet rs = null;
		Connection conn = null;
		String sGuid = "";
		String mailTag ="";
		try{	
			conn = ARE.getDBConnection("als");
			
			// ���Guid
			String sql = "select sys_Guid() as Guid From dual";
			prepareStatement = conn.prepareStatement(sql);
			rs = prepareStatement.executeQuery(sql);
			if (rs.next())
				sGuid = rs.getString("Guid");
			rs.close();
			prepareStatement.close();
			
			for(EmailRecBean eMail : eMails){
				mailTag += eMail.getFrom() + ":" + eMail.getSubject() + "  \n";
				//�����С����Ԥ��,�����Ͷ��Ÿ�ָ����ϵ��
				if(eMail.getSubject().trim().equals(LIMIT_ALERT)){
					for(String phoneNo : alertPhoneNos){
						//ʵ����һ��OCIRequestParam����
						OCIRequestParam req = new OCIRequestParam();
						//���Ĭ�ϲ�������Ҫ��ӵ�Ĭ�ϲ�������ע
						req.putDefaultValue("BRANCH", "000");	//����ȡ���л�����
						req.putDefaultValue("MOBILE_NO", phoneNo);
						req.putDefaultValue("CONTENT", "�������䳬���˴�С���ƣ��뾡�촦��");
						//OCIClientFacade.sendShortMessage(req);
					}
				}
			}
			if(mailTag.getBytes().length > 2000){
				mailTag = mailTag.substring(0, 2000);
			}
			
			EmailReceiver er = new EmailReceiver(reqParam);
			eMails =  er.readNewMail();	//�����ʼ�
			for(EmailRecBean eMail : eMails){
				mailTag += eMail.getFrom() + ":" + eMail.getSubject() + "  \n";
			}
			if(mailTag.getBytes().length > 2000){
				mailTag = mailTag.substring(0, 2000);
			}
			ARE.getLog().debug("Read New Mail========== " + mailTag);
			//Tools.saveKeyInfo(sGuid, "", "", mailTag, "");
		}catch(Exception e){	
			try {
				//Tools.saveErrorInfo(sGuid, ExceptionFactory.getErrorMsg(e, "�ʼ���ȡ����"));
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			ExceptionFactory.printErrorInfo(e);
		}finally{
			try{
				if(rs!=null)rs.close();
				if(prepareStatement!=null)prepareStatement.close();
				if(conn!=null)conn.close();
			}catch(Exception e){
				
			}
		}
		return eMails;
	}

	/**************************************************************
	 * ���������ò�����
	 * username;			// �û���
	 * password;			//����
	 * ============================================================
	 * ����ѡ���ò�����
	 * hostName;			//imap�ʼ��������� Ĭ��Ϊ"imap.sohu.com"
	 * saveAttachPath;		//�������غ�Ĵ��Ŀ¼
     * -------------------------------------------------------
     *����ȡ�����ʼ���
	 * @param reqParam 		���ò�������
	 * @return EmailRecBean ��װ�õ��ʼ����ض���
	 * @throws Exception 
	 **************************************************************/
	public List<EmailRecBean> readAllMail(Map<String, String> reqParam) throws Exception {
		List<EmailRecBean> eMail = null;
		Connection conn = null;
		PreparedStatement prepareStatement = null;
		ResultSet rs = null;
		String sGuid = "";
		try{	
			conn = ARE.getDBConnection("als");
			// ���Guid
			String sql = "select sys_Guid() as Guid From dual";
			
			EmailReceiver er = new EmailReceiver(reqParam);
			eMail =  er.readAllMail();	//�����ʼ�
		}catch(Exception e){
			try {
				//Tools.saveErrorInfo(sGuid, ExceptionFactory.getErrorMsg(e, "�ʼ���ȡ����"));
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			ExceptionFactory.printErrorInfo(e);
		}finally{
			try{
				if(rs!=null)rs.close();
				if(prepareStatement!=null)prepareStatement.close();
				if(conn!=null)conn.close();
			}catch(Exception e){
				
			}
		}
		return eMail;
	}

	/*******************************************************************************************
	 * �������ʼ���
	 * @param reqParam ���ò�������
	 * @return TransReceiver ��װ�õĽ��׷��ض���
	 * =========================================================================================
	 * ���������ò�����
	 * subject;	//�ʼ�����
	 * username;	// �û���
	 * password;	//����
	 * List<String> to;	//�ʼ����͵�ַ FORMAT: [xxx@srvname.com name] ���� [xxx@srvname.com] 	
	 * =========================================================================================
	 * ����ѡ���ò�����
	 * hostName;	//smtp�ʼ��������� Ĭ��Ϊ"smtp.bea.com"
	 * charset; //�ʼ�����ʱ�ı���
	 * debug;	//�ʼ������Ƿ���debug��־���	true/false
	 * sentDate;	//�ʼ�����ʱ��	yyyy-MM-dd
	 * smtpPort;	//smtp�������˿ں�
	 * sslSmtpPort;	//ssl��smtp�������Ķ˿ں�
	 * popBeforeSmtp;	//�Ƿ�ʹ��pop3������		true/false
	 * popHost;	//pop3��������
	 * popUsername;	//pop3��¼�û���
	 * popPassword;	//pop3��¼����
	 * timeOut;	//���ӳ�ʱʱ��
	 * List<String> cc;	//�ʼ����͵�ַ FORMAT: [xxx@srvname.com name] ���� [xxx@srvname.com] 
	 * List<String> bcc;	//�ʼ����͵�ַ FORMAT: [xxx@srvname.com name] ���� [xxx@srvname.com] 
	 * List<String> replyTo;	//�ʼ��ظ���ַ FORMAT: [xxx@srvname.com name] ���� [xxx@srvname.com] 
	 * msg;	//�ʼ�����
	 * List<EmailAttachment> attachments; //��������
	 * -------------------------------------------------------
     * Used to specify the mail headers.  Example:
     *
     * X-Mailer: Sendmail, X-Priority: 1( highest )
     * or  2( high ) 3( normal ) 4( low ) and 5( lowest )
     * Disposition-Notification-To: user@domain.net
     * xPriority;	//�ʼ����ȼ�
     * dispositionNotificationTo;	//�ʼ���ִ��ַ
     * -------------------------------------------------------
	 ************************************************************************************************/
	public OCIReceiver sendMail(Map<String, Object> reqParam) throws Exception{
		OCIReceiver ociReceiver = new OCIReceiver();
		Connection conn = null;
		PreparedStatement prepareStatement = null;
		ResultSet rs = null;
		String sGuid = "";
		String mailContect = "[" + (String)reqParam.get("subject") + "]:" + (String)reqParam.get("subject");
		if(mailContect.getBytes().length > 2000)
			mailContect = mailContect.substring(0, 2000);
		try{	
			
			conn = ARE.getDBConnection("als");
			
			// ���Guid
			String sql = "select sys_Guid() as Guid From dual";
			String messageId = doSendMail(reqParam);	//�����ʼ�
			ARE.getLog().debug("===========messageId==============[" + messageId + "]");
			ociReceiver.setEnable(true);
			ociReceiver.setReturnInfo(sGuid);
		}catch(Exception e){
			ociReceiver.setEnable(false);
			ociReceiver.setReturnInfo(ExceptionFactory.getErrorMsg(e, "�ʼ����ʹ���"));
			try {
				//Tools.saveErrorInfo(sGuid, ExceptionFactory.getErrorMsg(e, "�ʼ����ʹ���"));
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			ExceptionFactory.printErrorInfo(e);
		}finally{
			try{
				if(rs!=null)rs.close();
				if(prepareStatement!=null)prepareStatement.close();
				if(conn!=null)conn.close();
			}catch(Exception e){
				
			}
		}
		return ociReceiver;
	}

	private String doSendMail(Map<String, Object> reqParam) throws OCIException {
		String messageId = "";
		try{
			//����ʼ����ʹ�����
			EmailSender eMail = getMailHandler(reqParam);
			//�����ʼ�
			messageId = eMail.send();
			ARE.getLog().debug("�ʼ����ͳɹ�   messageId:" + messageId);
			
		}catch(Exception e){
			e.printStackTrace();
			ARE.getLog().error(e.getMessage(), e);
			ExceptionFactory.parse(e, "�����ʼ�");		
		}
		return messageId;
	}
	
	private EmailSender getMailHandler(Map<String, Object> reqParam) throws OCIException {
		ARE.getLog().debug("�����ʼ���������");
		Connection conn=null;
		EmailSender eMail = null;;
		try{
			conn = ARE.getDBConnection("als");
			
			if(reqParam.get("attachments") == null){
				eMail = new SimpleEmail();
			}else if(((List)reqParam.get("attachments")).size() == 0){
				eMail = new SimpleEmail();
			}else{
				eMail = new MultiPartEmail();
				for(EmailAttachment attachment : (List<EmailAttachment>)reqParam.get("attachments")){
					((MultiPartEmail)eMail).attach(attachment);
				}
			}
			
			//���ñ��������
			if(reqParam.get("subject") == null){
				throw new DataFormatException("Email subject not set");
			}else{
				eMail.setSubject((String)reqParam.get("subject"));
			}
			
			if(reqParam.get("hostName") == null){
				eMail.setHostName(MailInstance.hostName);
			}else{
				eMail.setHostName((String)reqParam.get("hostName"));
			}
			
			if(reqParam.get("username") == null){
				reqParam.put("username", MailInstance.username);
			}
			
			if(reqParam.get("password") == null){
				reqParam.put("password", MailInstance.password);
			}

			if(reqParam.get("username") == null){
				throw new DataFormatException("Email username not set");
			}else if (reqParam.get("password") == null){
				throw new DataFormatException("Email password not set");
			}else{
				eMail.setAuthentication((String)reqParam.get("username"), (String)reqParam.get("password"));
				if(MailInstance.displayName ==null||MailInstance.displayName.equals("")){
//					eMail.setFrom((String)reqParam.get("username") + "@" + eMail.getHostName().substring("smtp.".length()));
					throw new DataFormatException("ϵͳ��������δ����");
				}else{
					eMail.setFrom(MailInstance.displayName);
				}
				
			}
			
			if(reqParam.get("to") == null){
				throw new DataFormatException("Email to Address not set");
			}else if(((List)reqParam.get("to")).size() == 0){
				throw new DataFormatException("Email to Address not set");
			}else{
				for( String to : (List<String>)reqParam.get("to")){
					String[] toAddrs = to.split(" ");
					if(toAddrs.length == 1){
						eMail.addTo(toAddrs[0]);
					}else if(toAddrs.length == 2){
						eMail.addTo(toAddrs[0], toAddrs[1]);
					}else{
						throw new DataFormatException("Email to Address format not right");
					}
				}
			}
			//���ÿ�ѡ����
			if(reqParam.get("charset") != null){
				eMail.setCharset((String)reqParam.get("charset"));
			}else{
				eMail.setCharset(ARE.getProperty("CharSet","GBK"));
			}
			if(reqParam.get("debug") != null){
				eMail.setDebug(Boolean.parseBoolean((String)reqParam.get("debug")));
			}
			if(reqParam.get("sentDate") != null){
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				eMail.setSentDate(sdf.parse((String)reqParam.get("sentDate")));
			}
			if(reqParam.get("smtpPort") != null){
				eMail.setSmtpPort(Integer.parseInt((String)reqParam.get("smtpPort")));
			}
			if(reqParam.get("sslSmtpPort") != null){
				eMail.setSslSmtpPort((String)reqParam.get("sslSmtpPort"));
			}
			if(reqParam.get("popBeforeSmtp") != null && reqParam.get("popHost") != null
					&& reqParam.get("popUsername") != null && reqParam.get("popPassword") != null){
				eMail.setPopBeforeSmtp(Boolean.parseBoolean((String)reqParam.get("popBeforeSmtp")), 
						(String)reqParam.get("popHost"), (String)reqParam.get("popUsername"),
						(String)reqParam.get("popPassword"));
			}
			if(reqParam.get("timeOut") != null){
				eMail.setSslSmtpPort((String)reqParam.get("timeOut"));
			}
			if(reqParam.get("cc") != null){
				if(((List)reqParam.get("cc")).size() > 0){
					for( String cc : (List<String>)reqParam.get("cc")){
						String[] ccAddrs = cc.split(" ");
						if(ccAddrs.length == 1){
							eMail.addCc(ccAddrs[0]);
						}else if(ccAddrs.length == 2){
							eMail.addTo(ccAddrs[0], ccAddrs[1]);
						}else{
							throw new DataFormatException("Email cc Address format not right");
						}
					}
				}	
			}	
			if(reqParam.get("bcc") != null){
				if(((List)reqParam.get("bcc")).size() > 0){
					for( String bcc : (List<String>)reqParam.get("bcc")){
						String[] bccAddrs = bcc.split(" ");
						if(bccAddrs.length == 1){
							eMail.addBcc(bccAddrs[0]);
						}else if(bccAddrs.length == 2){
							eMail.addTo(bccAddrs[0], bccAddrs[1]);
						}else{
							throw new DataFormatException("Email bcc Address format not right");
						}
					}
				}	
			}	
			if(reqParam.get("replyTo") != null){
				if(((List)reqParam.get("replyTo")).size() > 0){
					for( String replyTo : (List<String>)reqParam.get("replyTo")){
						String[] replyToAddrs = replyTo.split(" ");
						if(replyToAddrs.length == 1){
							eMail.addReplyTo(replyToAddrs[0]);
						}else if(replyToAddrs.length == 2){
							eMail.addTo(replyToAddrs[0], replyToAddrs[1]);
						}else{
							throw new DataFormatException("Email replyTo Address format not right");
						}
					}
				}	
			}	
			if(reqParam.get("msg") != null){
				if(eMail instanceof SimpleEmail)
					((SimpleEmail)eMail).setMsg((String)reqParam.get("msg"));
				else 
					((MultiPartEmail)eMail).setMsg((String)reqParam.get("msg"));
			}
			Map<String, String> ht = new HashMap<String, String>();
			if(reqParam.get("xPriority") != null){
				ht.put("X-Priority", (String)reqParam.get("xPriority"));
		        
			}
			if(reqParam.get("dispositionNotificationTo") != null){
				ht.put("Disposition-Notification-To", (String)reqParam.get("dispositionNotificationTo"));
			}
			ht.put("X-Mailer", "Sendmail");
			eMail.setHeaders(ht);
		}catch(Exception e){
			e.printStackTrace();
			ARE.getLog().error(e.getMessage(), e);
			ExceptionFactory.parse(e, "�����ʼ�");		
		}
		return eMail;
	}
	
	/**
	 * 	�ƶ������ʼ�����
	 * @param reqParam ������Ϣ��msg; ����subject; �ռ���list to
	 * @return
	 */
	public OCIReceiver sendApproveMail(Map<String, Object> reqParam)throws Exception{
		//����У����
		String checkCode = "";
		DecimalFormat df = new DecimalFormat("0000000");
		checkCode = df.format(Math.random()*1000000);

		OCIReceiver ociReceiver = new OCIReceiver();
		Connection conn = null;
		PreparedStatement prepareStatement = null;
		ResultSet rs = null;
		String sql ="";
		String sGuid = "";
		try{	
			conn = ARE.getDBConnection("als");
			
			ociReceiver = sendMail(reqParam);	//�����ʼ�
			
		}catch(Exception e){
			ociReceiver.setEnable(false);
			ociReceiver.setReturnInfo(ExceptionFactory.getErrorMsg(e, "�ʼ����ʹ���"));	
			ExceptionFactory.printErrorInfo(e);
		}finally{
			try{
				if(rs!=null)rs.close();
				if(prepareStatement!=null)prepareStatement.close();
				if(conn!=null)conn.close();
			}catch(Exception e){
				
			}
		}
		return ociReceiver;
		
	}
	
	/**
	 * �ƶ������ʼ���������
	 * @param reqParam	����username���û���;	password������
	 * 
	 * @return
	 */
	public List<EmailRecBean> readApproveMail(Map<String, String> reqParam) throws Exception{
		List<EmailRecBean> emailRecBeans = readNewMail(reqParam);
		List<EmailRecBean> checkedEmails = new ArrayList<EmailRecBean>();
		for(EmailRecBean email : emailRecBeans){
			if(checkEmail(email))
				checkedEmails.add(email);
			else
				email.setUnSeen();
		}
		return checkedEmails;
	}
	
	private boolean checkEmail(EmailRecBean email)throws Exception{
		boolean flag = false;
		Connection conn=null;
		PreparedStatement prepareStatement = null;
		ResultSet rs = null;
		try{
			conn = ARE.getDBConnection("als");
			
			String subject = email.getSubject();
			String from = email.getFrom();
			ARE.getLog().debug("read Email subject============[" + subject + "]");
			ARE.getLog().debug("read Email from============[" + from + "]");
			ARE.getLog().debug("checkEmail attribute1:::" + subject.substring(subject.indexOf("=")+1, subject.lastIndexOf("=")));
			ARE.getLog().debug("checkEmail attribute3:::" + "[" + from.substring(from.indexOf("<")+1, from.length() -1).trim().toUpperCase() + "]");
			flag = true;
		}catch(Exception e){
			ExceptionFactory.printErrorInfo(e);
		}finally{
			try{
				if(rs!=null)rs.close();
				if(prepareStatement!=null)prepareStatement.close();
				if(conn!=null)conn.close();
			}catch(Exception e){
				
			}
		}
		return flag;
	}
	
	public static void main(String arg[]){
		Map<String, Object> reqParam = new HashMap<String, Object>();
		reqParam.put("subject", "OCI example");
		reqParam.put("hostName", "smtp.163.com");
		reqParam.put("username", "fj168104");
		reqParam.put("password", "826251");
		List<String> list = new ArrayList<String>(); 
		list.add("fj168104@163.com");
		reqParam.put("to", list);
		EmailAttachment attachment = new EmailAttachment();
        attachment.setPath("C:\\CBC_PSD_request_20120203_165034_.xml");
        attachment.setName("OCI_Attachment");
        attachment.setDescription("OCI Attachment Desc");
        
        EmailAttachment attachment2 = new EmailAttachment();
        attachment2.setPath("C:\\CBC_PSD_request_20120203_165034_.xml");
        attachment2.setName("OCI_Attachment2");
        attachment2.setDescription("OCI Attachment Desc2");
        
        List<EmailAttachment> list1 = new ArrayList<EmailAttachment>(); 
        list1.add(attachment);
        list1.add(attachment2);
        reqParam.put("attachments", list1);
		//MailInstance.getInstance().sendMail(reqParam);
	}
}
