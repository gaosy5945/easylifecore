package com.amarsoft.app.als.sys.tools;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.config.impl.SystemDBConfig;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 名称转化
 * @author qzhang1
 *
 */
public class SYSNameManager{

	//只能查询方案产品，基础产品返回空串
	public static String getProductName(String productID) throws Exception{
		if(StringX.isEmpty(productID)) return "";
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject prd = bom.keyLoadBusinessObject("jbo.prd.PRD_PRODUCT_LIBRARY", productID);
		if(prd == null) return "";
		return prd.getString("ProductName")	;
	}
	
	public static String getOrgNames(String orgIDs)  throws Exception{
		if(orgIDs == null || "".equals(orgIDs)) return "";
		StringBuffer name = new StringBuffer();
		String[] orgList = orgIDs.split(",");
		for(int i = 0; i < orgList.length ; i ++)
		{	if(i < orgList.length-1)
				name.append(SystemDBConfig.getOrg(orgList[i]).getString("OrgName")+",");
			else
				name.append(SystemDBConfig.getOrg(orgList[i]).getString("OrgName"));
		}
		return name.toString();
	}
	
	public static String getTermName(String termID) throws Exception{
		if(termID==null||termID.equals("")) return "";

		String TermName = "";
		try{
			
			BusinessObject bo = BusinessComponentConfig.getComponent(termID); 
			if(bo==null)
				TermName="";
			else
			   TermName=bo.getAttribute("Name").getString();

		}catch(Exception e){
			e.printStackTrace();
		}
		return TermName;
	}
	
	
	public static String getChangeFlag(String documentObjectType,String documentObjectNo,String parentTransSerialNo) throws Exception
	{
		String changeFlag = "原记录";
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION");
		//BizObjectQuery boq = bm.createQuery("DocumentObjectType=:DocumentObjectType and DocumentObjectNo=:DocumentObjectNo and ParentTransSerialNo= :ParentTransSerialNo");
		BizObjectQuery boq = bm.createQuery("DocumentObjectType=:DocumentObjectType and DocumentObjectNo=:DocumentObjectNo");
		boq.setParameter("DocumentObjectType", documentObjectType);
		boq.setParameter("DocumentObjectNo", documentObjectNo);
		//boq.setParameter("ParentTransSerialNo", parentTransSerialNo);
		BizObject bo = boq.getSingleResult(false);
		if(bo!=null)
		{
			changeFlag = bo.getAttribute("TransactionName").getString();
		}
		if("jbo.guaranty.GUARANTY_CONTRACT".equals(documentObjectType)){
			BizObjectManager bom=JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT_CHANGE");
			BizObjectQuery bq1 = bom.createQuery("GCSerialNo=:GCSerialNo ");
			bq1.setParameter("GCSerialNo", documentObjectNo);
			BizObject bo1 = bq1.getSingleResult(false);
			if(bo1 != null) {
				BizObjectQuery bq2 = bm.createQuery("DocumentObjectType=:DocumentObjectType and DocumentObjectNo=:DocumentObjectNo");
				bq2.setParameter("DocumentObjectType", "jbo.guaranty.GUARANTY_CONTRACT_CHANGE");
				bq2.setParameter("DocumentObjectNo", bo1.getAttribute("SerialNo").toString());
				BizObject bo2 = bq2.getSingleResult(false);
				if(bo2 != null)
					changeFlag = bo2.getAttribute("TransactionName").getString();
			}	
		}
		return changeFlag;
	}
	//查询是否合作方
	public static String getIsPartner(String CertType,String CertID,String CustomerID) throws Exception
	{
		String changeFlag = "否";
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
		BizObjectQuery boq = bm.createQuery("CertType=:CertType and CertID=:CertID and CustomerID=:CustomerID"); 
		boq.setParameter("CertType", CertType);
		boq.setParameter("CertID", CertID);
		boq.setParameter("CustomerID", CustomerID);
		BizObject bo = boq.getSingleResult(false);
		if(bo!=null)
		{
			changeFlag = "是";
		}
		return changeFlag;
	}
	//截取行业类型，并拼出行业大类码值
	public static String IndustryMain(String Industry) throws Exception
	{
		String IndustryFirst = substring(Industry, "0", "1");
		if("".equals(IndustryFirst)){
			return "";
		}else{
			return IndustryFirst + "0000";
		}
	}
	
	//十级分类转换为五级分类
	public static  String[] getFiveClassify(String classifyResult) throws Exception{	
		if (classifyResult.equals("01") ||classifyResult.equals("02") ||classifyResult.equals("03")||classifyResult.equals("04")||classifyResult.equals("05")){
			return new String[]{"01","正常"};
		}else if (classifyResult.equals("06") ||classifyResult.equals("07")){
			return new String[]{"02","关注"};
		}else if (classifyResult.equals("08")){
			return new String[]{"03","次级"};
		}else if (classifyResult.equals("09")){
			return new String[]{"04","可疑"};
		}else
			return new String[]{"05","损失"};
	}
	
	//字符串截取
	public static String substring(String str,String beginIndex, String endIndex)
	{
		if(str == null || "".equals(str)) return "";
		//modified by jqliang 2015-03-09 防止字符串越界
        if(str.length()<=Integer.parseInt(beginIndex)) return "";
        if(str.length()>Integer.parseInt(beginIndex) && str.length()<Integer.parseInt(endIndex)){
        	return str.substring(Integer.parseInt(beginIndex),str.length());
        } 
		return str.substring(Integer.parseInt(beginIndex), Integer.parseInt(endIndex));
	}
	
	
	//获取档案业务资料归属
	@Deprecated
	public static String getDocBelong(String objectType,String objectNo) throws Exception
	{
		if("jbo.app.BUSINESS_CONTRACT".equalsIgnoreCase(objectType))
		{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
			boq.setParameter("SerialNo", objectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo!=null)
			{
				String productID = bo.getAttribute("ProductID").getString();
				if(productID == null)
				{
					productID = bo.getAttribute("BusinessType").getString();
				}
				BusinessObject prdbo = ProductConfig.getProduct(productID);
				if(prdbo != null)
				{
					String productType2 = prdbo.getString("PRODUCTTYPE2");
					if("2".equals(productType2))  return "额度";
					else return "贷款";
				}
			}
			return "贷款";
		}
		else if("jbo.prj.PRJ_BASIC_INFO".equalsIgnoreCase(objectType))
		{
			return "合作项目";
		}
		return "贷款";
	}
	
	//取得合同中方案产品编号
	public static String getProductID(String ObjectNo) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
		boq.setParameter("SerialNo", ObjectNo);
		BizObject bo = boq.getSingleResult(false);
		String productID="";
		if(bo!=null)
		{
			productID = bo.getAttribute("ProductID").getString();
			if(productID == null)
			{
				productID = bo.getAttribute("BusinessType").getString();
			}
		}
		return productID;
	}
	
	//取得合同中方案产品编号
	public static String getProductNames(String ObjectNo) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
		boq.setParameter("SerialNo", ObjectNo);
		BizObject bo = boq.getSingleResult(false);
		String productID="";
		if(bo!=null)
		{
			productID = bo.getAttribute("ProductID").getString();
			if(productID == null)
			{
				productID = bo.getAttribute("BusinessType").getString();
			}
		}
		return getProductName(productID);
		}

	//根据资料编号获取资料名称
	public static String getFileName(String FileID) throws Exception
	{
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_CONFIG");
		BizObjectQuery boq = bm.createQuery("FileID=:FileID and FileFormat = '03' and Status = '1'  and ImageFileID is not null"); 
		boq.setParameter("FileID", FileID);
		BizObject bo = boq.getSingleResult(false);
		String FileName="";
		if(bo!=null)
		{
			FileName = bo.getAttribute("FileName").getString();
		}
		return FileName;
	}
	
	
	//获取档案业务资料客户名称
	public static String getDocCustomerName(String objectType,String objectNo) throws Exception
	{
		if("jbo.app.BUSINESS_CONTRACT".equalsIgnoreCase(objectType))
		{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
			boq.setParameter("SerialNo", objectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo!=null)
			{
				return bo.getAttribute("CustomerName").getString();
			}
			return "";
		}
		else if("jbo.prj.PRJ_BASIC_INFO".equalsIgnoreCase(objectType))
		{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			BizObjectQuery boq = bm.createQuery("CustomerID in (select PBI.CustomerID from jbo.prj.PRJ_BASIC_INFO PBI where PBI.SerialNo=:SerialNo)"); 
			boq.setParameter("SerialNo", objectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo!=null)
			{
				return bo.getAttribute("CustomerName").getString();
			}
			return "";
		}
		return "";
	}
	
	
	//获取档案业务资料客户名称
	public static String getDocOrgName(String objectType,String objectNo) throws Exception
	{
		if("jbo.app.BUSINESS_CONTRACT".equalsIgnoreCase(objectType))
		{
			BizObjectManager bm=JBOFactory.getBizObjectManager(objectType);
			BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
			boq.setParameter("SerialNo", objectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo!=null)
			{
				BusinessObject org = SystemDBConfig.getOrg(bo.getAttribute("EXECUTIVEORGID").getString());
				if(org != null)
				{
					return org.getString("OrgName");
				}
			}
			return "";
		}
		else if("jbo.prj.PRJ_BASIC_INFO".equalsIgnoreCase(objectType))
		{
			BizObjectManager bm=JBOFactory.getBizObjectManager(objectType);
			BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
			boq.setParameter("SerialNo", objectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo!=null)
			{
				if(bo.getAttribute("INPUTORGID") == null || "".equals(bo.getAttribute("INPUTORGID"))) return "";
				BusinessObject org = SystemDBConfig.getOrg(bo.getAttribute("INPUTORGID").getString());
				if(org != null)
				{
					return org.getString("OrgName");
				}
			}
			return "";
		}
		return "";
	}
	//签署意见时间
		public static String ApproveTime(String inputDate,String inputTime){
			return String.valueOf(inputDate+" "+inputTime);
		}
	//月到年月转换(额度的用到期日减今天算)
	public static String Month2YearMonth(String month,String day,String MaturityDate) throws Exception{
		if(month == null || "".equals(month) || "null".equals(month)) month = "0";
		if(day == null || "".equals(day)) day = "0";
		if("0".equals(day) && "0".equals(month)){
			if(MaturityDate == null || "".equals(MaturityDate)){
				return "0年0月0天";
			}else{
				int months = (int) Math.floor(DateHelper.getMonths(DateHelper.getBusinessDate(),MaturityDate));
				int days = DateHelper.getDays(DateHelper.getRelativeDate(DateHelper.getBusinessDate(), DateHelper.TERM_UNIT_MONTH, months), MaturityDate);
				return months/12+"年"+months%12+"月"+days+"天";
			}
		}
		return String.valueOf(((int)Double.parseDouble(month))/12+"年"+((int)Double.parseDouble(month))%12+"月"+((int)Double.parseDouble(day))+"天");
	}
	//月到年月转换
	public static String Month2YearMonth(String month,String day) throws Exception{
		return Month2YearMonth(month, day, "");
	}
	//月到年转换
	public static String Month2Year(String month)
	{
		if(month == null || "".equals(month) || "null".equals(month)) return "0";
		return String.valueOf(((int)Double.parseDouble(month))/12);
	}
	
	//月转换到年剩余
	public static String Month2YearMod(String month)
	{
		if(month == null || "".equals(month) || "null".equals(month)) return "0";
		return String.valueOf(((int)Double.parseDouble(month))%12);
	}
	
	//获取档案业务资料业务品种
	public static String getBusinessType(String objectType,String objectNo) throws Exception
	{	
		if("jbo.app.BUSINESS_CONTRACT".equalsIgnoreCase(objectType))
		{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TYPE");
			BizObjectQuery boq = bm.createQuery("O.TypeNo in(SELECT BC.BusinessType FROM jbo.app.BUSINESS_CONTRACT BC WHERE BC.SerialNo=:SerialNo)"); 
			boq.setParameter("SerialNo", objectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo!=null)
			{
				return  bo.getAttribute("TypeName").getString();
			}
			return "";
		}
		else if("jbo.prj.PRJ_BASIC_INFO".equalsIgnoreCase(objectType))
		{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			BizObjectQuery boq = bm.createQuery("SerialNo=:SerialNo"); 
			boq.setParameter("SerialNo", objectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo!=null)
			{
				return bo.getAttribute("ProjectName").getString();
			}
			return "";
		}
		return "";
	}
	
	
	/**
	 * 对已经审批通过的业务，计算其申请状态
	 * @param applySerialNo
	 * @param approveStatus
	 * @return
	 * @throws Exception
	 */
	public static String getApplyPassStatusName(String applySerialNo,String approveStatus) throws Exception{
		
		if("03".equals(approveStatus))
		{
			BizObjectManager bpm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
			BizObjectQuery bpq = bpm.createQuery("select O.PutOutStatus from O where O.ApplySerialNo=:ApplySerialNo"); 
			bpq.setParameter("ApplySerialNo", applySerialNo);
			BizObject bp = bpq.getSingleResult(false);
			if(bp!=null)
			{
				String putoutStatus = bp.getAttribute("PutOutStatus").getString();
				if("02".equals(putoutStatus)) return "放款审核通过";
				else if("03".equals(putoutStatus)) return "放款监督通过 ";
				else if("05".equals(putoutStatus)) return "已入账";
				else return "审批通过";
			}
			else
			{
				BizObjectManager bcm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
				BizObjectQuery bcq = bcm.createQuery("select O.ContractStatus from O where O.ApplySerialNo=:ApplySerialNo"); 
				bcq.setParameter("ApplySerialNo", applySerialNo);
				BizObject bc = bcq.getSingleResult(false);
				if(bc!=null)
				{
					String contractStatus = bc.getAttribute("ContractStatus").getString();
					if("01".equals(contractStatus)) return "审批通过 ";
					else if("02".equals(contractStatus)) return "放款监督通过 ";
					else return "已入账";
				}
			}
		}
		else
		{
			Item item = CodeCache.getItem("BusinessApproveStatus", approveStatus);
			if(item != null)
			{
				return item.getItemName();
			}
		}
		
		return "审批通过";
	}
	//当老数据中意见说明是文件路径时，把文件内容读出来
	public static String getPhaseOpinionEdit(String PhaseOpinion) throws Exception
	{
		StringBuffer sb = new StringBuffer();
		if(PhaseOpinion.indexOf("$@") > -1){
			String aa = Configure.getInstance().getConfigure("FileSavePath");
			String ss = aa + PhaseOpinion.substring(2);
			File dFile = null;
            dFile = new File(ss);
            if((dFile.exists())){
            	BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(ss)));
            	String sLine;
            	while((sLine = reader.readLine())!= null){
            		sb.append(sLine);
            	}
            	reader.close();
            }else{
            	return "文件不存在！";
            }
            return sb.toString();
		}
		return PhaseOpinion;
	}
	public static String getLoanTypeAndName(String LoanType) throws Exception{
		return LoanType+"-"+CodeCache.getItemName("BusinessType_Core", LoanType);
	}
	public static String getGuaranTorName(String AISerialNo) throws Exception{
		BizObjectManager gc=JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
		BizObjectQuery gcq = gc.createQuery("select O.GuaranTorName from O where O.SerialNo=(select max(GR.GCSerialNo) from jbo.guaranty.GUARANTY_RELATIVE GR where GR.AssetSerialNo = :AssetSerialNo)");
		gcq.setParameter("AssetSerialNo", AISerialNo);
		String GuarantorName = "";
		BizObject bp = gcq.getSingleResult(false);
		if(bp!=null)
		{
			GuarantorName = bp.getAttribute("GuaranTorName").getString();
		}
		return GuarantorName;
	}
	
	
	public static String getFloorMonth(String beginDate,String endDate) throws Exception{
		return String.valueOf((int)Math.floor(DateHelper.getMonths(beginDate,endDate)));
	}
	
	public static String getModDay(String beginDate,String endDate) throws Exception{
		int month = (int)Math.floor(DateHelper.getMonths(beginDate, endDate));
		int day = DateHelper.getDays(DateHelper.getRelativeDate(beginDate, DateHelper.TERM_UNIT_MONTH, month), endDate);
		return String.valueOf(day);
	}
}
