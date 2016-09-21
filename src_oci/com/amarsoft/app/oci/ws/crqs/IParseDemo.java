package com.amarsoft.app.oci.ws.crqs;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.List;

import com.amarsoft.app.crqs2.AmarIParseManager;
import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.parse.from.IParseReportMessage;
import com.amarsoft.app.crqs2.thread.i.IBuildSQLHandler;
import com.amarsoft.app.crqs2.tool.FileProcessHandler;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.CommandLineArgument;

public class IParseDemo {
	public static void main(String[] args) throws FileNotFoundException {
		
		int flag = 13;

		CommandLineArgument arg = new CommandLineArgument(args);
		String DEFAULT_ARE_CONFIG = "etc/are.xml";
		String are = arg.getArgument("are", DEFAULT_ARE_CONFIG);
		ARE.init(are);

		/**���������ñ���ת��ΪHTML�ļ�
		 * @xmlFile	�������ĸ������ñ����ļ�
		 * @path	HTML�ļ����·��
		 */
		if(flag==0){
			new AmarIParseManager().parseHTMLFileByFile("E:/parse_test/0_110108195607175419_������_2012070400000603910787.xml", "E:/parse_test/icr.html");
		}
		
		/**���������ñ���ת��Ϊ�����
		 * @xmlFile	�������ĸ������ñ����ļ�
		 * @out		���������
		 */
		if(flag==1){
			PrintWriter out = new PrintWriter("sd");
			new AmarIParseManager().parseHTMLWriterByFile("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml", out);
		}
		
		/**���������ñ���ת��Ϊ��HTML�ļ�-�ַ��߼�1
		 * @xmlFile	�������ĸ������ñ����ļ�
		 * @path	HTML�ļ����·��
		 */
		if(flag==2){
			new AmarIParseManager().parseHTMLFileByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml", "C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\�������ű���-spd.html");
		}
		
		/**���������ñ���ת��ΪHTML�ļ�-�ַ��߼�2
		 * @xmlFile		�������ĸ������ñ���
		 * @path		HTML�ļ����·��
		 * @webUserCode	ƽ̨�û����
		 * @webUserName	ƽ̨�û�����
		 */
		if(flag==3){
			new AmarIParseManager().parseHTMLFileByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml", "C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\�������ű���2-spd.html", "110", "����");
		}
		
		/**��xmlת��Ϊ�����-�ַ��߼�1
		 * @xmlFile		�������ĸ������ñ���
		 * @webUserCode	ƽ̨�û����
		 * @webUserName	ƽ̨�û�����
		 * @out			���������
		 */
		if(flag==4){
			PrintWriter out = new PrintWriter("sd");
			new AmarIParseManager().parseHTMLWriterByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml", out, "001", "����");
		}
		
		/**��xmlת��Ϊ�����-�ַ��߼�2
		 * @xmlFile		�������������ñ����ļ�
		 * @out			���������
		 */
		if(flag==5){
			PrintWriter out = new PrintWriter("sd");
			new AmarIParseManager().parseHTMLWriterByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml", out);
		}
		
		/**��xml����ת��ΪHTML�ĵ�
		 * @msg		�������ñ���xml����
		 * @path	HTML�ļ����·��
		 */
		if(flag==6){
			String msg = new FileProcessHandler().fileToString("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml");
			new AmarIParseManager().parseHTMLFileByString(msg, "C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\�������ű���3.html");
		}
		
		/**ͨ��SQL��ѯ��ȡHTML�ļ�
		 * @reportSN	�������ñ�����
		 * @path		HTML�ļ����·��
		 */
		if(flag==7){
			String reportSN="2012090400000604398348";
			new AmarIParseManager().parseHTMLFileBySQL(reportSN, "C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\�������ű���4.html");
		}
		
		/**ͨ��SQL��ѯ��ȡ���������
		 * @reportSN	�������ñ�����
		 * @path		����ļ�
		 * @out			���������
		 */
		if(flag==8){
			String reportSN="2012090400000604398348";
			PrintWriter out = new PrintWriter("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\�������ű���5.html");
			new AmarIParseManager().parseHTMLWriterBySQL(reportSN, out);
		}
		
		/**�����Ķ���ת��ΪHTML�ļ�
		 * @message	���Ķ���	
		 * @path	HTML�ļ�·��
		 */
		if(flag==9){
			String msg = new FileProcessHandler().fileToString("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml");//��xml����ת��Ϊ�ַ���
			String queryType = "single";//��ѯ������ͣ�single������batch
			IReportMessage message = new IParseReportMessage().createObjectFromXML(msg, queryType);//��䱨�Ķ���
			String path = "C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\�������ű���6.html";
			int count = 1;
			new AmarIParseManager().parseHTMLFileByIRM(message, path, count);
		}
		
		/**�����Ķ���ת��ΪHTML�����
		 * @message	���Ķ���
		 * @out		���������
		 * @count	������������,Ŀǰ��ѡֵΪ1,2,3�е�һ��
		 */
		if(flag==10){
			IReportMessage message = new IParseReportMessage().createObjectFromXML("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml", "single");
			PrintWriter out = new PrintWriter("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\�������ű���7.html");
			new AmarIParseManager().parseHTMLWriterByIRM(message, out, 1);
		}
		
		/**���������ݱ��浽���ݿ���
		 * @msg			��������
		 * @queryType	�������ͣ�single����batch
		 */
		if(flag==11){
			String msg = new FileProcessHandler().fileToString("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml");
			String queryType = "single";
			new AmarIParseManager().saveXMLByMsg(msg, queryType);
		}
		
		/**�����Ķ��󱣴浽���ݿ���
		 * @message	���Ķ���
		 */
		if(flag==11){
			IReportMessage message = new IParseReportMessage().createObjectFromXML("C:\\Users\\Administrator\\Desktop\\temp\\���Ų���\\dsaddsaf.xml", "single");
			new AmarIParseManager().saveXMLByIRM(message, "single");
		}
		
		/**������xml�ļ����浽���ݿ���
		 * @parent		xml�ļ����ڵ��ļ���
		 * @queryType	��ѯ������ͣ�single������batch
		 */
		if(flag==12){
			String parent = "";
			new AmarIParseManager().saveXMLByFiles(parent, "single");
		}
		
		/**
		 * ���߳����ñ������
		 */
		if (flag == 13) {
			// ���ñ����ļ�����
			List<File> fileList = new LinkedList<File>();
			fileList.add(new File("E:/parse_test/0_110108195607175419_������_2012070400000603910787.xml"));
			new IBuildSQLHandler(fileList).execute();
		}
	}
}
