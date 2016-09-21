package com.amarsoft.app.oci.instance.mail;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.mail.BodyPart;
import javax.mail.Flags;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Part;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

import com.amarsoft.app.oci.exception.DataFormatException;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.ARE;

public class EmailRecBean {

	private MimeMessage mimeMessage = null;
	private String saveAttachPath = "d:/"; // �������غ�Ĵ��Ŀ¼
	private StringBuffer bodytext = new StringBuffer(); // ����ʼ����ݵ�StringBuffer����
	private String dateformat = "yy-MM-dd HH:mm"; // Ĭ�ϵ���ǰ��ʾ��ʽ
	
	/**
	 * ���캯��,��ʼ��һ��MimeMessage����
	 */
	public EmailRecBean() {
		
	}

	public EmailRecBean(MimeMessage mimeMessage) {
		this.mimeMessage = mimeMessage;
		getMailContent((Part)this.mimeMessage);
	}

	public void setMimeMessage(MimeMessage mimeMessage) {
		this.mimeMessage = mimeMessage;
		getMailContent((Part)this.mimeMessage);
	}
	
	/**
	 * ��÷����˵ĵ�ַ������
	 */
	public String getFrom() throws Exception {
		InternetAddress address[] = (InternetAddress[]) mimeMessage.getFrom();
		String from = address[0].getAddress();
		if (from == null)
			from = "";
		String personal = address[0].getPersonal();
		if (personal == null)
			personal = "";
		String fromaddr = personal + "<" + from + ">";
		return fromaddr;
	}
	
	/**
	 * ����ʼ����ռ��ˣ����ͣ������͵ĵ�ַ�����������������ݵĲ����Ĳ�ͬ "TO"----�ռ��� "CC"---�����˵�ַ "BCC"---�����˵�ַ
	 */
	public String getMailAddress(String type) throws Exception {
		String mailaddr = "";
		String addtype = type.toUpperCase();
		InternetAddress[] address = null;
		if (addtype.equals("TO") || addtype.equals("CC")
				|| addtype.equals("BCC")) {
			if (addtype.equals("TO")) {
				address = (InternetAddress[]) mimeMessage
						.getRecipients(Message.RecipientType.TO);
			} else if (addtype.equals("CC")) {
				address = (InternetAddress[]) mimeMessage
						.getRecipients(Message.RecipientType.CC);
			} else {
				address = (InternetAddress[]) mimeMessage
						.getRecipients(Message.RecipientType.BCC);
			}
			if (address != null) {
				for (int i = 0; i < address.length; i++) {
					String email = address[i].getAddress();
					if (email == null)
						email = "";
					else {
						email = MimeUtility.decodeText(email);
					}
					String personal = address[i].getPersonal();
					if (personal == null)
						personal = "";
					else {
						personal = MimeUtility.decodeText(personal);
					}
					String compositeto = personal + "<" + email + ">";
					mailaddr += "," + compositeto;
				}
				mailaddr = mailaddr.substring(1);
			}
		} else {
			throw new Exception("Error emailaddr type!");
		}
		return mailaddr;
	}
	
	/**
	 * ����ʼ�����
	 */
	public String getSubject() throws MessagingException {
		String subject = "";
		try {
			subject = MimeUtility.decodeText(mimeMessage.getSubject());
			if (subject == null)
				subject = "";
		} catch (Exception exce) {
		}
		return subject;
	}

	/**
	 * ����ʼ���������
	 */
	public String getSentDate() throws Exception {
		Date sentdate = mimeMessage.getSentDate();
		SimpleDateFormat format = new SimpleDateFormat(dateformat);
		return format.format(sentdate);
	}

	/**
	 * ����ʼ���������
	 * @throws Exception 
	 */
	public String getBodyText() throws Exception {
		return bodytext.toString();
	}

	/**
	 * �����ʼ����ѵõ����ʼ����ݱ��浽һ��StringBuffer�����У������ʼ� ��Ҫ�Ǹ���MimeType���͵Ĳ�ִͬ�в�ͬ�Ĳ�����һ��һ���Ľ���
	 */
	private void getMailContent(Part part) {
		String contenttype;
		int nameindex;
		bodytext = new StringBuffer();
		try {
			contenttype = part.getContentType();
			nameindex = contenttype.indexOf("name");
			boolean conname = false;
			if (nameindex != -1)
				conname = true;

			if (part.isMimeType("text/plain") && !conname) {
				bodytext.append((String) part.getContent());
			} else if (part.isMimeType("text/html") && !conname) {
				bodytext.append((String) part.getContent());
			} else if (part.isMimeType("multipart/*")) {
				Multipart multipart = (Multipart) part.getContent();
				int counts = multipart.getCount();
				for (int i = 0; i < counts; i++) {
					getMailContent(multipart.getBodyPart(i));
				}
			} else if (part.isMimeType("message/rfc822")) {
				getMailContent((Part) part.getContent());
			} else {
			}
		} catch (MessagingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	/**
	 * �жϴ��ʼ��Ƿ���Ҫ��ִ�������Ҫ��ִ����"true",���򷵻�"false"
	 */
	public boolean getReplySign() throws MessagingException {
		boolean replysign = false;
		String needreply[] = mimeMessage
				.getHeader("Disposition-Notification-To");
		if (needreply != null) {
			replysign = true;
		}
		return replysign;
	}

	/**
	 * ��ô��ʼ���Message-ID
	 */
	public String getMessageId() throws MessagingException {
		return mimeMessage.getMessageID();
	}

	/**
	 * ���жϴ��ʼ��Ƿ��Ѷ������δ�����ط���true,��֮����false��
	 */
	public boolean isNew() throws MessagingException {
		boolean isnew = false;
		Flags flags = ((Message) mimeMessage).getFlags();
		//���ʼ��Ļ�flags.toString() = javax.mail.Flags@30,���ǵ������Ļ��ͻ���javax.mail.Flags@20
		isnew = flags.toString().equals("javax.mail.Flags@30");
		return isnew;
	}
	
	/**
	 * �����ʼ�����Ϊ�Ѷ���
	 */
	public void setSeen() throws MessagingException{
		mimeMessage.setFlag(Flags.Flag.SEEN, false);
	}
	
	/**
	 * �����ʼ�����Ϊδ����
	 */
	public void setUnSeen(){
		try {
			mimeMessage.setFlag(Flags.Flag.SEEN, true);
		} catch (MessagingException e) {
			e.printStackTrace();
		}
	}
	

	/**
	 * �жϴ��ʼ��Ƿ��������
	 */
	public boolean isContainAttach() throws Exception {
		return isContainAttach((Part)mimeMessage);
	}
	
	private boolean isContainAttach(Part part) throws Exception {
		boolean attachflag = false;
		if (part.isMimeType("multipart/*")) {
			Multipart mp = (Multipart) part.getContent();
			for (int i = 0; i < mp.getCount(); i++) {
				BodyPart mpart = mp.getBodyPart(i);
				String disposition = mpart.getDisposition();
				if ((disposition != null)
						&& ((disposition.equals(Part.ATTACHMENT)) || (disposition
								.equals(Part.INLINE))))
					attachflag = true;
				else if (mpart.isMimeType("multipart/*")) {
					attachflag = isContainAttach((Part) mpart);
				} else {
					String contype = mpart.getContentType();
					if (contype.toLowerCase().indexOf("application") != -1)
						attachflag = true;
					if (contype.toLowerCase().indexOf("name") != -1)
						attachflag = true;
				}
			}
		} else if (part.isMimeType("message/rfc822")) {
			attachflag = isContainAttach((Part) part.getContent());
		}
		return attachflag;
	}

	/**
	 * �����渽����
	 */
	public void saveAttachMent() throws Exception {
		saveAttachMent((Part)mimeMessage);
	}
	
	private void saveAttachMent(Part part) throws Exception {
		String fileName = "";
		if (part.isMimeType("multipart/*")) {
			Multipart mp = (Multipart) part.getContent();
			for (int i = 0; i < mp.getCount(); i++) {
				BodyPart mpart = mp.getBodyPart(i);
				String disposition = mpart.getDisposition();
				if ((disposition != null)
						&& ((disposition.equals(Part.ATTACHMENT)) || (disposition
								.equals(Part.INLINE)))) {
					fileName = mpart.getFileName();
					if (fileName.toLowerCase().indexOf("gb2312") != -1) {
						fileName = MimeUtility.decodeText(fileName);
					}
					saveFile(fileName, mpart.getInputStream());
				} else if (mpart.isMimeType("multipart/*")) {
					saveAttachMent(mpart);
				} else {
					fileName = mpart.getFileName();
					if ((fileName != null)
							&& (fileName.toLowerCase().indexOf("GB2312") != -1)) {
						fileName = MimeUtility.decodeText(fileName);
						saveFile(fileName, mpart.getInputStream());
					}
				}
			}
		} else if (part.isMimeType("message/rfc822")) {
			saveAttachMent((Part) part.getContent());
		}
	}

	/**
	 * �����ø������·����
	 */
	public void setAttachPath(String attachpath) {
		this.saveAttachPath = attachpath;
	}

	/**
	 * ������������ʾ��ʽ��
	 */
	public void setDateFormat(String format) throws Exception {
		this.dateformat = format;
	}
	
	/**
	 * ����ȡ������ʾ��ʽ��
	 */
	public String getDateFormat() throws Exception {
		return this.dateformat;
	}

	/**
	 * ����ø������·����
	 */
	public String getAttachPath() {
		return saveAttachPath;
	}

	/**
	 * �������ı��渽����ָ��Ŀ¼�
	 */
	private void saveFile(String fileName, InputStream in) throws OCIException {
		String storedir = getAttachPath();
		BufferedOutputStream bos = null;
		BufferedInputStream bis = null;
		if(storedir == null)
			throw new DataFormatException(" Email attachment saving path not set");
		File store = new File(storedir);
		if(!store.exists()){
			store.mkdir();
		}
		ARE.getLog().trace("�ʼ��������·��: " + store.getAbsolutePath());
		File storefile = new File(storedir + "/" + fileName);
		ARE.getLog().trace("����ʼ�����: " + storefile.toString());
		
		try {
			bos = new BufferedOutputStream(new FileOutputStream(storefile));
			bis = new BufferedInputStream(in);
			int c;
			while ((c = bis.read()) != -1) {
				bos.write(c);
				bos.flush();
			}
			ARE.getLog().trace("�����ѱ��浽" + storedir);
		} catch (Exception e) {
			ExceptionFactory.parse(e, "��������ʧ��");
		} finally {
			try {
				if(bos != null)
					bos.close();
				if(bis != null)
					bis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	
}
