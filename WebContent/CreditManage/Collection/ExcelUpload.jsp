<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@page import="com.amarsoft.app.als.dataimport.ExcelImportManager"%>
<%@page import="java.util.Date"%>
<%@page import="jxl.*"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.app.urge.OutCollExcelImportAction" %>
<script type="text/javascript">
<%!

public static boolean dateCheck(String data){
	try {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        dateFormat.setLenient(false);
        Date d = dateFormat.parse(data);
        return true;
	}catch (Exception e) {
		e.printStackTrace();
		return false;
	}
}

public static String dateConvert(String data){
	try {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        dateFormat.setLenient(false);
        Date d = dateFormat.parse(data);
        return dateFormat.format(d);
	}catch (Exception e) {
		e.printStackTrace();
	}
	return data;
}
//得到sheet表的实际行数，
	int getSheetRowNumber(Sheet rs){
		int sheetRowNumber=0;
		int sheetClounmNumber=0;
		sheetClounmNumber=rs.getColumns();
		int rowTotalNumber=50000;
		rowTotalNumber=rs.getRows();
		sheetRowNumber=rowTotalNumber;
		String rowValue="";
		while(sheetRowNumber>=0){
			for(int i=0;i<sheetClounmNumber;i++){
				rowValue=rowValue+rs.getCell(i,sheetRowNumber-1).getContents().trim();
			}
			//从所得的最大行数开始如果空行就减一
			if(rowValue=="" || rowValue==null || "".equals(rowValue)){
				sheetRowNumber--;
			}else{
				//return sheetRowNumber;
				break;
			}
		}
		return sheetRowNumber;
	}
%>
<% 

File file = null;
FileInputStream inputStream = null;
boolean Flag = true;
try{
	
    AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
    myAmarsoftUpload.initialize(pageContext);
    myAmarsoftUpload.upload();

    String filePathName = myAmarsoftUpload.getFiles().getFile(0).getFilePathName();
    String fileName = myAmarsoftUpload.getFiles().getFile(0).getFileName();
   
    String sFileSavePath = CurConfig.getConfigure("FileSavePath");
    if(sFileSavePath==null)throw new Exception("请在als7.xml中配置文件存放路径FileSavePath");
    
    //创建存放目录
    String excelSaveDirectory = sFileSavePath+"/excelimport";
    File saveDic = new File(excelSaveDirectory);//如果没有该目录，则创建
    if(!saveDic.exists())saveDic.mkdirs();
    
    //存文件
    out.println("document.writeln('文件上传中...<br/>');");
    out.flush();
   	String sFileFullPath = excelSaveDirectory+"/"+System.currentTimeMillis()+fileName;
	
    myAmarsoftUpload.getFiles().getFile(0).saveAs(sFileFullPath);
    
    file = new File(sFileFullPath);
    //解析文件
    out.println("document.writeln('文件上传完成，正在解析...，请勿关闭窗口<br/>');");

    out.flush();
    String pattern = "[\r\n]+";
    inputStream = new FileInputStream(file);
    Workbook wb = Workbook.getWorkbook(inputStream); //得到工作薄
    Sheet sheet = wb.getSheet(0);
    int iRowCount = 0;
    int iColumn = 0;

    try
    {
    	//iRowCount = Integer.parseInt(sheet.getCell("B1").getContents().replaceAll(pattern, ""));
    	iRowCount = sheet.getRows();//getSheetRowNumber(rs);
    	iColumn = sheet.getColumns(); //获得总列数  
    	
    }catch(Exception ex)
    {
    	out.println("document.writeln('EXCEL中笔数录入错误，必须录入数字且要与列表笔数相同！<br/>');");
    	ex.printStackTrace();
   		throw ex;
    }
    
%>          
<script type="text/javascript">
	 //alert(getHtmlMessage(10));//上传文件失败！
	 //parent.openComponentInMe();
</script>
<script type="text/javascript">
    //alert(getHtmlMessage(13));//上传文件成功！
    //parent.openComponentInMe();
</script>
<script language=javascript>
	//self.close();
</script>
<%
	for(int i = 3 ; i <= 2+iRowCount; i ++){
		String sBankFlag = "2"; //是否本行票据*
		String sBillNo = sheet.getCell("A"+i).getContents().replaceAll(pattern, ""); //票据号码*
		String sBillSum = sheet.getCell("B"+i).getContents().replaceAll(pattern, "");//票面金额*
		String sWRITEDATE = sheet.getCell("C"+i).getContents().replaceAll(pattern, "");//票据签发日*
		String sMATURITY = sheet.getCell("D"+i).getContents().replaceAll(pattern, "");//票据到期日*
		String sFinishDate = sheet.getCell("E"+i).getContents().replaceAll(pattern, "");//贴现日期*
		String sBeginDate = sheet.getCell("F"+i).getContents().replaceAll(pattern, "");//票据查询回复日期*
		String sACCEPTORREGION = sheet.getCell("G"+i).getContents().replaceAll(pattern, "");//票据来源*
		String sEndorseTimes = sheet.getCell("H"+i).getContents().replaceAll(pattern, "");//调整天数*
		String sRate = sheet.getCell("I"+i).getContents().replaceAll(pattern, "");//贴现月利率(‰)*
		String sASSUREDISCOUNTFLAG = sheet.getCell("J"+i).getContents().replaceAll(pattern, "");//是否有保贴函*
		String sASSUREDISCOUNTNO = sheet.getCell("K"+i).getContents().replaceAll(pattern, ""); //保贴函协议号*
		String sACCEPTOR = sheet.getCell("L"+i).getContents().replaceAll(pattern, "");//承兑人名称*
		String sACCEPTORID = sheet.getCell("M"+i).getContents().replaceAll(pattern, "");//承兑行行号*
		String sDeductAccNo = sheet.getCell("N"+i).getContents().replaceAll(pattern, "");//放款账号*
		
		//校验开始
		try {
			Double.parseDouble(sBillSum);
		} catch(Exception ex) {
			out.println("document.writeln('第"+(i-2)+"行数据【票据金额】有误！<br/>');");
			Flag = false;
		}
		
		if(!this.dateCheck(sWRITEDATE)) {
			out.println("document.writeln('第"+(i-2)+"行数据【票据签发日】未按照YYYY/MM/DD格式填写！<br/>');");
			Flag = false;
		} else {
			sWRITEDATE = this.dateConvert(sWRITEDATE);
		}
		
		try
		{
			Integer.parseInt(sEndorseTimes);
		}
		catch(Exception ex)
		{
			out.println("document.writeln('第"+(i-2)+"行数据【调整天数】有误！<br/>');");
			Flag = false;
		}
		
		if(sMATURITY!=null && sMATURITY.compareTo(sFinishDate) < 0){
			out.println("document.writeln('第"+(i-2)+"行数据【票据到期日】不能小于【贴现日期】，请检查！<br/>');");
			Flag = false;
		}
		String sACCEPTORCUSTOMERID = "";
		if("1".equals(sASSUREDISCOUNTFLAG) && (sASSUREDISCOUNTNO == null || "".equals(sASSUREDISCOUNTNO)))
		{
			out.println("document.writeln('第"+(i-2)+"行数据有保贴函，未录入【保贴函协议号】，请检查！<br/>');");
			Flag = false;
		}
		
		BizObjectManager manager = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
		int iCount=manager.createQuery("BillNo=:BillNo and FinishDate is not null and FinishDate <> ' ' and ObjectType = :ObjectType and ObjectNo = :ObjectNo").setParameter("BillNo",sBillNo).setParameter("ObjectType","").setParameter("ObjectNo","").getTotalCount();
		if(iCount > 0){
			out.println("document.writeln('第"+(i-2)+"行数据【票据号:" + sBillNo + "】已存在，请检查！<br/>');");
			Flag = false;
		}
		if(Flag)
		{
			//String sACCEPTORSAMPLE = sACCEPTORID.substring(0,3);
			//String sACCEPTORCITY = "test";//sACCEPTORID.substring(3,7);
			//String sACCEPTORPROVINCEID = Sqlca.getString("select SortNo from CODE_LIBRARY where CodeNo = 'BankCity' and ItemNo = '"+sACCEPTORCITY+"'");
			
			BizObjectManager bom = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
			BizObject boBb = bom.newObject();
			String sSerialNo2 = DBKeyHelp.getSerialNo("BILL_INFO", "SerialNo",Sqlca);
	
			boBb.setAttributeValue("SerialNo",sSerialNo2);
			boBb.setAttributeValue("ObjectType","");
			boBb.setAttributeValue("ObjectNo","");
			boBb.setAttributeValue("IsLocalBill","2");
			boBb.setAttributeValue("BillNo",sBillNo);
			boBb.setAttributeValue("BillSum",sBillSum);
			boBb.setAttributeValue("WRITEDATE",sWRITEDATE);
			boBb.setAttributeValue("MATURITY",sMATURITY);
			boBb.setAttributeValue("FinishDate",sFinishDate);
			boBb.setAttributeValue("BeginDate",sBeginDate);
			boBb.setAttributeValue("HolderID",sACCEPTORREGION);
			boBb.setAttributeValue("EndorseTimes",sEndorseTimes);
			boBb.setAttributeValue("Rate",sRate);
			//boBb.setAttributeValue("ACCEPTORPROVINCEID",sACCEPTORPROVINCEID);
			//boBb.setAttributeValue("ACCEPTORCITY",sACCEPTORCITY);
			//boBb.setAttributeValue("ACCEPTORSAMPLE",sACCEPTORSAMPLE);
			boBb.setAttributeValue("Acceptor",sACCEPTOR);
			boBb.setAttributeValue("ACCEPTORID",sACCEPTORID);
			boBb.setAttributeValue("DeductAccNo",sDeductAccNo);
			//boBb.setAttributeValue("ACCEPTORCUSTOMERID",sACCEPTORCUSTOMERID);
			boBb.setAttributeValue("ISSAFEGUARD",sASSUREDISCOUNTFLAG);
			boBb.setAttributeValue("SAFEGUARDPROTOCOL",sASSUREDISCOUNTNO);
			boBb.setAttributeValue("InputUserID",CurUser.getUserID());
			boBb.setAttributeValue("InputOrgID",CurUser.getOrgID());
			boBb.setAttributeValue("InputDate",StringFunction.getToday());
			boBb.setAttributeValue("UpdateDate",StringFunction.getToday());
			bom.saveObject(boBb);
		}
	}
	 

	//最后数据处理
	if(Flag){
		tx.commit();
		
		/* BillAction BA = new BillAction();
		BA.setObjectNo("");
		BA.setObjectType("");
		if("1".equals(sBillType)){
			BA.UpdateBusinessSum1();
		} else {
			BA.UpdateBusinessSum();
		} */
	} else {
		tx.rollback();
	}
	
	
	out.println("document.writeln('文件解析完成!<br/>');");
	}catch(Exception e){
		out.println("document.writeln('文件解析出错，请确认按照模板填写!<br/>');");
		ARE.getLog().error("上传并解析文件发生错误",e);
		Flag = false;
	}finally{
		if(inputStream!=null){
	        inputStream.close();
	        inputStream = null;
		}
		if(file!=null){
			if(file.exists()&&file.isFile()){
				boolean deleteSucess = file.delete();//完成后，删除文件
				if(!deleteSucess){
					ARE.getLog().debug("删除文件["+file.getAbsolutePath()+"]失败，该文件已不再使用，请定期清除");
				}else{
					ARE.getLog().trace("删除文件["+file.getAbsolutePath()+"]成功");
				}
			}
		}
		if(Flag)
		{
			out.println("top.returnValue='导入文件成功！';");
	   	 	out.println("top.close();");//上传文件成功！
		}
		else
		{
			out.println("top.returnValue='导入文件失败！';");
		}
	}
%>
</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>
