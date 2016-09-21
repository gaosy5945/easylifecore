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

		/**将个人信用报告转换为HTML文件
		 * @xmlFile	待解析的个人信用报告文件
		 * @path	HTML文件存放路径
		 */
		if(flag==0){
			new AmarIParseManager().parseHTMLFileByFile("E:/parse_test/0_110108195607175419_李龙云_2012070400000603910787.xml", "E:/parse_test/icr.html");
		}
		
		/**将个人信用报告转换为输出流
		 * @xmlFile	待解析的个人信用报告文件
		 * @out		输出流对象
		 */
		if(flag==1){
			PrintWriter out = new PrintWriter("sd");
			new AmarIParseManager().parseHTMLWriterByFile("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml", out);
		}
		
		/**将个人信用报告转换为个HTML文件-浦发逻辑1
		 * @xmlFile	待解析的个人信用报告文件
		 * @path	HTML文件存放路径
		 */
		if(flag==2){
			new AmarIParseManager().parseHTMLFileByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml", "C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\个人征信报告-spd.html");
		}
		
		/**将个人信用报告转换为HTML文件-浦发逻辑2
		 * @xmlFile		待解析的个人信用报告
		 * @path		HTML文件存放路径
		 * @webUserCode	平台用户编号
		 * @webUserName	平台用户姓名
		 */
		if(flag==3){
			new AmarIParseManager().parseHTMLFileByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml", "C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\个人征信报告2-spd.html", "110", "张三");
		}
		
		/**将xml转换为输出流-浦发逻辑1
		 * @xmlFile		待解析的个人信用报告
		 * @webUserCode	平台用户编号
		 * @webUserName	平台用户姓名
		 * @out			输出流对象
		 */
		if(flag==4){
			PrintWriter out = new PrintWriter("sd");
			new AmarIParseManager().parseHTMLWriterByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml", out, "001", "张三");
		}
		
		/**将xml转换为输出流-浦发逻辑2
		 * @xmlFile		待解析个人信用报告文件
		 * @out			输出流对象
		 */
		if(flag==5){
			PrintWriter out = new PrintWriter("sd");
			new AmarIParseManager().parseHTMLWriterByFile_spd("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml", out);
		}
		
		/**将xml内容转换为HTML文档
		 * @msg		个人信用报告xml内容
		 * @path	HTML文件存放路径
		 */
		if(flag==6){
			String msg = new FileProcessHandler().fileToString("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml");
			new AmarIParseManager().parseHTMLFileByString(msg, "C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\个人征信报告3.html");
		}
		
		/**通过SQL查询获取HTML文件
		 * @reportSN	个人信用报告编号
		 * @path		HTML文件存放路径
		 */
		if(flag==7){
			String reportSN="2012090400000604398348";
			new AmarIParseManager().parseHTMLFileBySQL(reportSN, "C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\个人征信报告4.html");
		}
		
		/**通过SQL查询获取输出流对象
		 * @reportSN	个人信用报告编号
		 * @path		输出文件
		 * @out			输出流对象
		 */
		if(flag==8){
			String reportSN="2012090400000604398348";
			PrintWriter out = new PrintWriter("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\个人征信报告5.html");
			new AmarIParseManager().parseHTMLWriterBySQL(reportSN, out);
		}
		
		/**将报文对象转换为HTML文件
		 * @message	报文对象	
		 * @path	HTML文件路径
		 */
		if(flag==9){
			String msg = new FileProcessHandler().fileToString("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml");//将xml内容转换为字符串
			String queryType = "single";//查询结果类型，single或者是batch
			IReportMessage message = new IParseReportMessage().createObjectFromXML(msg, queryType);//填充报文对象
			String path = "C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\个人征信报告6.html";
			int count = 1;
			new AmarIParseManager().parseHTMLFileByIRM(message, path, count);
		}
		
		/**将报文对象转换为HTML输出流
		 * @message	报文对象
		 * @out		输出流对象
		 * @count	输出对象的类型,目前可选值为1,2,3中的一种
		 */
		if(flag==10){
			IReportMessage message = new IParseReportMessage().createObjectFromXML("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml", "single");
			PrintWriter out = new PrintWriter("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\个人征信报告7.html");
			new AmarIParseManager().parseHTMLWriterByIRM(message, out, 1);
		}
		
		/**将报文内容保存到数据库中
		 * @msg			报文内容
		 * @queryType	保存类型，single或者batch
		 */
		if(flag==11){
			String msg = new FileProcessHandler().fileToString("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml");
			String queryType = "single";
			new AmarIParseManager().saveXMLByMsg(msg, queryType);
		}
		
		/**将报文对象保存到数据库中
		 * @message	报文对象
		 */
		if(flag==11){
			IReportMessage message = new IParseReportMessage().createObjectFromXML("C:\\Users\\Administrator\\Desktop\\temp\\征信测试\\dsaddsaf.xml", "single");
			new AmarIParseManager().saveXMLByIRM(message, "single");
		}
		
		/**批量将xml文件保存到数据库中
		 * @parent		xml文件所在的文件夹
		 * @queryType	查询结果类型，single或者是batch
		 */
		if(flag==12){
			String parent = "";
			new AmarIParseManager().saveXMLByFiles(parent, "single");
		}
		
		/**
		 * 多线程信用报告入库
		 */
		if (flag == 13) {
			// 信用报告文件队列
			List<File> fileList = new LinkedList<File>();
			fileList.add(new File("E:/parse_test/0_110108195607175419_李龙云_2012070400000603910787.xml"));
			new IBuildSQLHandler(fileList).execute();
		}
	}
}
