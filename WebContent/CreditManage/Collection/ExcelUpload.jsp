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
//�õ�sheet���ʵ��������
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
			//�����õ����������ʼ������оͼ�һ
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
    if(sFileSavePath==null)throw new Exception("����als7.xml�������ļ����·��FileSavePath");
    
    //�������Ŀ¼
    String excelSaveDirectory = sFileSavePath+"/excelimport";
    File saveDic = new File(excelSaveDirectory);//���û�и�Ŀ¼���򴴽�
    if(!saveDic.exists())saveDic.mkdirs();
    
    //���ļ�
    out.println("document.writeln('�ļ��ϴ���...<br/>');");
    out.flush();
   	String sFileFullPath = excelSaveDirectory+"/"+System.currentTimeMillis()+fileName;
	
    myAmarsoftUpload.getFiles().getFile(0).saveAs(sFileFullPath);
    
    file = new File(sFileFullPath);
    //�����ļ�
    out.println("document.writeln('�ļ��ϴ���ɣ����ڽ���...������رմ���<br/>');");

    out.flush();
    String pattern = "[\r\n]+";
    inputStream = new FileInputStream(file);
    Workbook wb = Workbook.getWorkbook(inputStream); //�õ�������
    Sheet sheet = wb.getSheet(0);
    int iRowCount = 0;
    int iColumn = 0;

    try
    {
    	//iRowCount = Integer.parseInt(sheet.getCell("B1").getContents().replaceAll(pattern, ""));
    	iRowCount = sheet.getRows();//getSheetRowNumber(rs);
    	iColumn = sheet.getColumns(); //���������  
    	
    }catch(Exception ex)
    {
    	out.println("document.writeln('EXCEL�б���¼����󣬱���¼��������Ҫ���б������ͬ��<br/>');");
    	ex.printStackTrace();
   		throw ex;
    }
    
%>          
<script type="text/javascript">
	 //alert(getHtmlMessage(10));//�ϴ��ļ�ʧ�ܣ�
	 //parent.openComponentInMe();
</script>
<script type="text/javascript">
    //alert(getHtmlMessage(13));//�ϴ��ļ��ɹ���
    //parent.openComponentInMe();
</script>
<script language=javascript>
	//self.close();
</script>
<%
	for(int i = 3 ; i <= 2+iRowCount; i ++){
		String sBankFlag = "2"; //�Ƿ���Ʊ��*
		String sBillNo = sheet.getCell("A"+i).getContents().replaceAll(pattern, ""); //Ʊ�ݺ���*
		String sBillSum = sheet.getCell("B"+i).getContents().replaceAll(pattern, "");//Ʊ����*
		String sWRITEDATE = sheet.getCell("C"+i).getContents().replaceAll(pattern, "");//Ʊ��ǩ����*
		String sMATURITY = sheet.getCell("D"+i).getContents().replaceAll(pattern, "");//Ʊ�ݵ�����*
		String sFinishDate = sheet.getCell("E"+i).getContents().replaceAll(pattern, "");//��������*
		String sBeginDate = sheet.getCell("F"+i).getContents().replaceAll(pattern, "");//Ʊ�ݲ�ѯ�ظ�����*
		String sACCEPTORREGION = sheet.getCell("G"+i).getContents().replaceAll(pattern, "");//Ʊ����Դ*
		String sEndorseTimes = sheet.getCell("H"+i).getContents().replaceAll(pattern, "");//��������*
		String sRate = sheet.getCell("I"+i).getContents().replaceAll(pattern, "");//����������(��)*
		String sASSUREDISCOUNTFLAG = sheet.getCell("J"+i).getContents().replaceAll(pattern, "");//�Ƿ��б�����*
		String sASSUREDISCOUNTNO = sheet.getCell("K"+i).getContents().replaceAll(pattern, ""); //������Э���*
		String sACCEPTOR = sheet.getCell("L"+i).getContents().replaceAll(pattern, "");//�ж�������*
		String sACCEPTORID = sheet.getCell("M"+i).getContents().replaceAll(pattern, "");//�ж����к�*
		String sDeductAccNo = sheet.getCell("N"+i).getContents().replaceAll(pattern, "");//�ſ��˺�*
		
		//У�鿪ʼ
		try {
			Double.parseDouble(sBillSum);
		} catch(Exception ex) {
			out.println("document.writeln('��"+(i-2)+"�����ݡ�Ʊ�ݽ�����<br/>');");
			Flag = false;
		}
		
		if(!this.dateCheck(sWRITEDATE)) {
			out.println("document.writeln('��"+(i-2)+"�����ݡ�Ʊ��ǩ���ա�δ����YYYY/MM/DD��ʽ��д��<br/>');");
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
			out.println("document.writeln('��"+(i-2)+"�����ݡ���������������<br/>');");
			Flag = false;
		}
		
		if(sMATURITY!=null && sMATURITY.compareTo(sFinishDate) < 0){
			out.println("document.writeln('��"+(i-2)+"�����ݡ�Ʊ�ݵ����ա�����С�ڡ��������ڡ������飡<br/>');");
			Flag = false;
		}
		String sACCEPTORCUSTOMERID = "";
		if("1".equals(sASSUREDISCOUNTFLAG) && (sASSUREDISCOUNTNO == null || "".equals(sASSUREDISCOUNTNO)))
		{
			out.println("document.writeln('��"+(i-2)+"�������б�������δ¼�롾������Э��š������飡<br/>');");
			Flag = false;
		}
		
		BizObjectManager manager = com.amarsoft.are.jbo.JBOFactory.getFactory().getManager("jbo.app.BILL_INFO");
		int iCount=manager.createQuery("BillNo=:BillNo and FinishDate is not null and FinishDate <> ' ' and ObjectType = :ObjectType and ObjectNo = :ObjectNo").setParameter("BillNo",sBillNo).setParameter("ObjectType","").setParameter("ObjectNo","").getTotalCount();
		if(iCount > 0){
			out.println("document.writeln('��"+(i-2)+"�����ݡ�Ʊ�ݺ�:" + sBillNo + "���Ѵ��ڣ����飡<br/>');");
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
	 

	//������ݴ���
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
	
	
	out.println("document.writeln('�ļ��������!<br/>');");
	}catch(Exception e){
		out.println("document.writeln('�ļ�����������ȷ�ϰ���ģ����д!<br/>');");
		ARE.getLog().error("�ϴ��������ļ���������",e);
		Flag = false;
	}finally{
		if(inputStream!=null){
	        inputStream.close();
	        inputStream = null;
		}
		if(file!=null){
			if(file.exists()&&file.isFile()){
				boolean deleteSucess = file.delete();//��ɺ�ɾ���ļ�
				if(!deleteSucess){
					ARE.getLog().debug("ɾ���ļ�["+file.getAbsolutePath()+"]ʧ�ܣ����ļ��Ѳ���ʹ�ã��붨�����");
				}else{
					ARE.getLog().trace("ɾ���ļ�["+file.getAbsolutePath()+"]�ɹ�");
				}
			}
		}
		if(Flag)
		{
			out.println("top.returnValue='�����ļ��ɹ���';");
	   	 	out.println("top.close();");//�ϴ��ļ��ɹ���
		}
		else
		{
			out.println("top.returnValue='�����ļ�ʧ�ܣ�';");
		}
	}
%>
</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>
