<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<!-- 
    һ��ҵ������ Ȩ֤�嵥��ӡ 
 -->
<%
	//��ȡ�������:ѺƷ��š�����������ͬ��ˮ��
	String sAssetSerialNo =  DataConvert.toString(CurPage.getParameter("SerialNo"));
	String sContractSerialNo = DataConvert.toString(CurPage.getParameter("ContractSerialNo"));

	//������������ͬ�š��ͻ����ơ�ҵ�������š�ҵ���������ơ�����
	String sBCSerialNo="",sCustomerName="",sBusinessType="",sBusinessTypeName="",sBusinessTerm="";
	String sBusinessSum = "";//���Ž��
	//����ѺƷ��Ż�ȡ��ͬ�����Ϣ
	String sSql ="select bc.serialno,bc.customername,bc.businesstype,bc.businesssum,bc.businessterm"+
				" from business_contract bc where bc.serialno ='"+sContractSerialNo+"'";
	ASResultSet rs = Sqlca.getASResultSet2(sSql);
	
	if(rs.next()){
		sBCSerialNo = rs.getString("serialno");
		sCustomerName = rs.getString("customername");
		sBusinessType = rs.getString("businesstype");
		sBusinessSum =  DataConvert.toMoney(rs.getString("businesssum"));
		sBusinessTerm = rs.getString("businessterm"); 
	}
    rs.getStatement().close();
	String PUTOUTDATE = "";
	try{
		PUTOUTDATE = Sqlca.getString("Select PUTOUTDATE from business_putout where contractserialno = '"+sBCSerialNo+"'").toString();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	if(PUTOUTDATE == null) PUTOUTDATE = "";
		String YEAR = "";
		String MONTH = "";
		String DATE = "";
	try{
		YEAR = PUTOUTDATE.substring(0, 4);//��
		MONTH = PUTOUTDATE.substring(5, 7);//��
		DATE = PUTOUTDATE.substring(8, 10);//��
	}catch(StringIndexOutOfBoundsException e){
		e.printStackTrace();
	}
	BizObject btbiz = null;
	try{
		btbiz = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_TYPE").createQuery("O.TYPENO = :BUSINESSTYPEID").setParameter("BUSINESSTYPEID",sBusinessType).getSingleResult();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	String BUSINESSTYPE = "";
	try{
		sBusinessTypeName = btbiz.getAttribute("TYPENAME").toString();//ҵ������ 
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	List<BizObject> list = null;
	try{
	   list = JBOFactory.getFactory().getManager("jbo.app.ASSET_RIGHT_CERTIFICATE").createQuery("O.ASSETSERIALNO = :ASSETSERIALNO").setParameter("ASSETSERIALNO",sAssetSerialNo).getResultList();
	}catch(NullPointerException e){
		e.printStackTrace();
	}
	int i = 0;
    String sCertType[]=new String[list.size()];//Ȩ֤���ͺ� 
	String sCertTypeName[]=new String[list.size()];//Ȩ֤��������
    String sCertNo[]=new String[list.size()];//Ȩ֤��
    for(BizObject biz: list){
		sCertType[i]=biz.getAttribute("CERTTYPE").toString(); 
		try{
			sCertTypeName[i]=Sqlca.getString("Select itemname from code_library where codeno = 'AssetCertType' and itemno='"+sCertType[i]+"'").toString();
		}catch(NullPointerException e){
			e.printStackTrace();
		}
		sCertNo[i]=biz.getAttribute("CERTNO").toString();//Ȩ֤��
		i++;
	}
	

%>
<style>
.td{ border-right:none; border-bottom:none;}
.table{ border-left:none; border-top:none;} 
</style>

<body>
<table width="598" border="0" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
  	<tr height="40">
	    <td colspan="7">
		    <div align="center">
		    <p class="STYLE1"  align=center style='text-align:center;line-height:150%; layout-grid-mode:char;font-size: 20px'>
		    <span lang=EN-US style='font-size:11.0pt;'>&nbsp;</span><b>ѺƷ����Ȩ֤����嵥</b>
		    </p>
		  	</div>
		</td>
  	</tr>
	<tr height="40">
		<td width="350" >&nbsp;</td>
		<td colspan="1">&nbsp;��ͬ��ţ�</td>
		<td colspan="1">&nbsp;<%=sBCSerialNo %></td>
	</tr>
</table>


<table width="598" border="0" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table">
	<tr height="40">
	    <td>&nbsp;���ࣺ</td>
	    <td colspan="6">&nbsp;<%=sBusinessTypeName %></td>
	</tr>
	<tr height="40">
		<td width="12%">&nbsp;����ˣ�</td>
		<td width="12%">&nbsp;<%=sCustomerName %></td>
		<td width="22%">&nbsp;&nbsp;�����/���ޣ�</td>
		<td width="30%"><%=sBusinessSum %>Ԫ&nbsp;/&nbsp;<%=sBusinessTerm%>��</td>
		<td width="15%">&nbsp;�ſ����ڣ�</td>
		<td colspan="2">&nbsp;&nbsp;<%=YEAR %>&nbsp;��&nbsp;&nbsp;&nbsp;<%=MONTH %>&nbsp;��&nbsp;&nbsp;<%=DATE %>&nbsp;&nbsp;��</td>
	</tr>
	<tr><td height="20px"></td></tr>
	<tr> 
		<td align="left" colspan="6"> 
			<table border='1' cellpadding='1' cellspacing = '0' class='table' >
				<tr height='40' align="center">
					<td width='20%' class='td'>&nbsp;</td>
					<td width='30%' align='center' class='td'>Ȩ֤����</td>
					<td align= 'center' class='td'>Ȩ֤��</td>
				</tr>
			
			<%for(int j=0;j<sCertNo.length;j++){ %>
			
				<tr height='40' align="center">
				<td align='center' class='td'><input type='checkbox' ></input></td>
				<td class='td'>&nbsp;<%=sCertTypeName[j]==null?"":sCertTypeName[j]%></td>
				<td class='td'>&nbsp;<%=sCertNo[j]%></td>
				</tr>
			
			<%} %>
			</table >
		</td>
	</tr>
</table>
<br><br>

<br><br>
<table width="598" border="0" cellpadding="3" bordercolor = "black" cellspacing = "0" id="table" >
	<tr height="40">
	<td >&nbsp;�ƽ��ˣ�</td>
	<td >&nbsp;</td>
	<td >&nbsp;�ӽ��ˣ�</td>
	<td >&nbsp;</td>
	<td >&nbsp;</td>
	<td colspan="2">&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;��</td>
	</tr>
</table>
<div id="print" onclick="printPaper()" style="width:100px;height:30px; text-align: center; line-height:30px;color:white; background-color:blue; border-radius:10px;cursor:pointer;">��ӡ</div>
    
</body> 
<script>
   function printPaper(){
	   var print = document.getElementById("print");
	   
	   if(window.confirm("�Ƿ�ȷ��Ҫ��ӡ��")){
		   //��ӡ	  
		   window.print();			  
	   }
   }
   $("#print").mouseenter(function(){
	   $("#print").css("backgroundColor","red");
   }).mouseleave(function(){
	   $("#print").css("backgroundColor","blue");
   })  
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
