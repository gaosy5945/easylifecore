package com.amarsoft.app.als.sys.tools;

import java.util.List;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.CodeManager;

public class DateReport {

/*	public static String getDueBalance(String contractno) throws Exception
	{
		String result = "";
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		BizObjectQuery boq = bm.createQuery("select v.count(O.serialno) as v.cnt from O where ContractSerialNo=:ContractNo"); 
		boq.setParameter("ContractNo", contractno);
		BizObject bo = boq.getSingleResult(false);
		if(bo!=null)
		{

			result = bo.getAttribute("cnt").getString();
		}
		return result;
	}
	
	public static String getDueSum(String contractno) throws Exception
	{
		String result = "";
		BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		BizObjectQuery boq = bm.createQuery("select sum(balance) as v.balance from O where ContractSerialNo=:ContractNo"); 
		boq.setParameter("ContractNo", contractno);
		BizObject bo = boq.getSingleResult(false);
		if(bo!=null)
		{

			result = bo.getAttribute("balance").getString();
		}
		return result;
	}*/
	
	//������λ
	public static String getEmployment(String customerid) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_RESUME");
		BizObjectQuery boq = bm.createQuery("select employment from O where enddate IS NULL and CustomerID=:CustomerID");
		boq.setParameter("CustomerID", customerid);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("employment").getString();
			if(result == null) result = "";
		}		
		return result;
	}
	
	//������λ������ҵ����λ���ʣ��������ϱߺϲ�
	public static String getIndustryAndNature(String customerid,String flag) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_RESUME");
		BizObjectQuery boq = bm.createQuery("select INDUSTRYTYPE,COMPANYNATURE from O where enddate IS NULL and CustomerID=:CustomerID");
		boq.setParameter("CustomerID", customerid);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			if(flag.equals("1.0"))
			{
				result = bo.getAttribute("INDUSTRYTYPE").getString();   //��ҵ����
				if(result == null) result = "";  
			}
			if(flag.equals("2.0"))
			{
				result = bo.getAttribute("COMPANYNATURE").getString(); //��λ����
				if(result == null) result = "";  
			}
		}		
		return result;
	}
	
	//����������Ŀ
	public static String getProject(String contractno) throws Exception
	{
		String result = "";
		String projectno = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		BizObjectQuery boq = bm.createQuery("select projectserialno from O "
				+ "where objecttype='jbo.app.BUSINESS_CONTRACT' and ObjectNO=:ContractNO");
		boq.setParameter("ContractNO",contractno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			projectno = bo.getAttribute("projectserialno").getString();
			bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			boq = bm.createQuery("select projectname from O where SerialNo=:SerialNo");
			boq.setParameter("SerialNo",projectno);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
				result = bo.getAttribute("projectname").getString();
				if(result == null) result = ""; 
			}
		}
		
		return result;
	}
	
	//����������
	public static String getProjectCustName(String contractno) throws Exception
	{
		String result = "";
		String projectno = "";
		String customerid = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
		BizObjectQuery boq = bm.createQuery("select projectserialno from O "
				+ "where objecttype='jbo.app.BUSINESS_CONTRACT' and ObjectNO=:ContractNO");
		boq.setParameter("ContractNO",contractno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			projectno = bo.getAttribute("projectserialno").getString();
			
			bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
			boq = bm.createQuery("select customerid from O where SerialNo=:SerialNo");
			boq.setParameter("SerialNo",projectno);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
				customerid = bo.getAttribute("customerid").getString();
				
				bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
				boq = bm.createQuery("select customername from O where customerid=:customerid");
				boq.setParameter("customerid",customerid);
				bo = boq.getSingleResult(false);
				if(bo != null)
				{
					result = bo.getAttribute("customername").getString();
					if(result == null) result = "";  
				}
			}
		}
		
		return result;
	}
	
	//��������
	public static String getLoanterm(String serialno) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
		BizObjectQuery boq = bm.createQuery(" select v.months_between(v.to_date(MATURITYDATE,'yyyy/mm/dd'),v.to_date(PUTOUTDATE,'yyyy/mm/dd')) "
				+ " as v.loanterm FROM O where serialno=:serialno");
		boq.setParameter("serialno", serialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("loanterm").getString();
			if(result == null) result = "";             //��ֹ��ָ���쳣
			
		}		
		return result;
	}
	
	//���ռ������
	public static String getcollterm(String operatedate) throws Exception
	{
		if(operatedate == null || "".equals(operatedate)) return "";
		String startDate = DateHelper.getBusinessDate();
		int day = DateHelper.getDays(operatedate,startDate);
		return String.valueOf(day);
	}

	//���մ���ʱ��
		public static String getcolltime(String ObjectNo) throws Exception
		{
			String result = "";
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK_PROCESS");
			BizObjectQuery boq = bm.createQuery(" SELECT v.max(O.PROCESSDATE) as v.processdate FROM O, jbo.coll.COLL_TASK CL  "
					+ " WHERE CL.ObjectType = 'jbo.app.BUSINESS_DUEBILL' "
					+ " AND CL.ObjectNo = :ObjectNo AND CL.SerialNo =O.TaskSerialNo ");
			boq.setParameter("ObjectNo",ObjectNo);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				result = bo.getAttribute("processdate").getString();
				if(result == null) result = "";             //��ֹ��ָ���쳣
				
			}		
			return result;
		}
	//������Ա
	public static String getApproveUserID(String approveserialno) throws Exception
	{
		String result = "";
		String userid = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		BizObjectQuery boq = bm.createQuery("select approveuserid FROM O where serialno=:approveserialno");
		boq.setParameter("approveserialno", approveserialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			userid = bo.getAttribute("approveuserid").getString();
			bm = JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
			boq = bm.createQuery("select username from O where userid=:userid");
			boq.setParameter("userid",userid);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
				result = bo.getAttribute("username").getString();
				if(result == null) result = "";  
			}
		}		
		return result;
	}
	
	//�Ƿ��������ڵ���
	public static String getIsIn2Months(String contractserialno) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery boq = bm.createQuery(" select (case when v.months_between(v.to_date(MATURITYDATE,'yyyy/mm/dd'),v.SYSDATE)>2 "
				+ "then '��' else '��' end)  as v.loanterm FROM O where objectno=:objectno");
		boq.setParameter("objectno", contractserialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("loanterm").getString();
			if(result == null) result = "";  
		}		
		return result;
	}
	//���ʽ����������.�������ֶζ�Ӧͬһ������
	public static String getRPTTerm(String rpttermid) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prd.PRD_COMPONENT_LIBRARY");
		BizObjectQuery boq = bm.createQuery("select componentname from O where componentid=:componentid ");
		boq.setParameter("componentid", rpttermid);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("componentname").getString();
			if(result == null) result = "";  
			return result;
		}
		return rpttermid;
	}
	
	
	//��ϵ��ַ
	public static String getAddress(String customerid) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.PUB_ADDRESS_INFO");
		BizObjectQuery boq = bm.createQuery("select (ADDRESS1 v.||PROVINCE v.||CITY v.||ADDRESS2 v.|| ADDRESS3 v.|| ADDRESS4) as v.address"
				+ " from O where addresstype='040' and isnew='1' and objecttype='jbo.customer.CUSTOMER_INFO' and objectno=:customerid ");
		boq.setParameter("customerid", customerid);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("address").getString();
			if(result == null) result = "";  
		}		
		return result;
	}
	
	//��������
	public static String getBirthday(String customerid) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_INFO");
		BizObjectQuery boq = bm.createQuery("select birthday from O where customerid=:customerid ");
		boq.setParameter("customerid", customerid);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("birthday").getString();
			if(result == null) result = "";  
		}		
		return result;
	}
	
	//���ѧ��
	public static String getEduexperience(String customerid) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.IND_INFO");
		BizObjectQuery boq = bm.createQuery("select eduexperience from O where customerid=:customerid ");
		boq.setParameter("customerid", customerid);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("eduexperience").getString();
			if(result == null) result = "";  
		}		
		return result;
	}
	
	//��ɫͨ��ҵ��
	public static String getGreenPass(String applyserialno) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		BizObjectQuery boq = bm.createQuery("select businesspriority from O where serialno=:applyserialno ");
		boq.setParameter("applyserialno", applyserialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("businesspriority").getString();
			if(result == null) result = "";  
		}		
		return result;
	}
	

	
	//�����������������
	public static String getAreaOrDate(String contractno,String flag) throws Exception
	{
		String result = "";
		String assetserialno = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TRADE");
		BizObjectQuery boq = bm.createQuery("select assetserialno from O "
				+ "where firstorsecond='01' and objecttype='jbo.app.BUSINESS_CONTRACT' and objectno=:contractno ");
		boq.setParameter("contractno", contractno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			assetserialno = bo.getAttribute("assetserialno").getString();
			 
			bm = JBOFactory.getBizObjectManager("jbo.guaranty.ASSET_REALTY");
			boq = bm.createQuery("select FloorArea,DeliveryDate from O where assetserialno=:assetserialno ");
			boq.setParameter("assetserialno", assetserialno);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
				if(flag.equals("1.0"))
				{
					result = bo.getAttribute("FloorArea").getString();   //�������
				}
				if(flag.equals("2.0"))
				{
					result = bo.getAttribute("DeliveryDate").getString(); //��������
				}
			}		
		}
		if(result==null)result="";
		return result;
	}
	//�������
/*	public static String getArea(String contractno) throws Exception
	{
		String result = "";
		String assetserialno = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TRADE");
		BizObjectQuery boq = bm.createQuery("select assetserialno from O "
				+ "where firstorsecond='01' and objecttype='jbo.app.BUSINESS_CONTRACT' and objectno=:contractno ");
		boq.setParameter("contractno", contractno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			assetserialno = bo.getAttribute("assetserialno").getString();
			 
			bm = JBOFactory.getBizObjectManager("jbo.guaranty.ASSET_REALTY");
			boq = bm.createQuery("select FloorArea from O where assetserialno=:assetserialno ");
			boq.setParameter("assetserialno", assetserialno);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
					result = bo.getAttribute("FloorArea").getString();   //�������

			}		
		}		
		return result;
	}*/
	//��������
/*	public static String getDate(String contractno) throws Exception
	{
		String result = "";
		String assetserialno = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TRADE");
		BizObjectQuery boq = bm.createQuery("select assetserialno from O "
				+ "where firstorsecond='01' and objecttype='jbo.app.BUSINESS_CONTRACT' and objectno=:contractno ");
		boq.setParameter("contractno", contractno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			assetserialno = bo.getAttribute("assetserialno").getString();
			 
			bm = JBOFactory.getBizObjectManager("jbo.guaranty.ASSET_REALTY");
			boq = bm.createQuery("select DeliveryDate from O where assetserialno=:assetserialno ");
			boq.setParameter("assetserialno", assetserialno);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
					result = bo.getAttribute("DeliveryDate").getString(); //��������
			}		
		}		
		return result;
	}*/
	
	public static String getProjectCustomer(String customerid) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		BizObjectQuery boq = bm.createQuery("select customername from O where customerid=:customerid");
		boq.setParameter("customerid",customerid);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			result = bo.getAttribute("customername").getString();
			if(result == null) result = "";  
		}	
		return result;
	}
	
	//������Ŀ����½����Ϣ
	public static String getProjectCLBill(String contractid,String flag) throws Exception
	{
		String result = "";
		if(contractid.equals("") || contractid == null)result ="0";
		else{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
			BizObjectQuery boq = bm.createQuery("select v.count(O.serialno) as v.cnt,v.sum(O.businesssum) as v.allsum,v.sum(O.balance) as v.balsum "
					+ " from O where contractserialno=:contractid");
			boq.setParameter("contractid",contractid);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				if(flag.equals("1.0"))
				{
					result = bo.getAttribute("cnt").getString();
					if(result == null) result = "";  
				}
				if(flag.equals("2.0"))
				{
					result = bo.getAttribute("allsum").getString();
					if(result == null) result = "0";             //��ֹ��ָ���쳣
				}
				if(flag.equals("3.0"))
				{
					result = bo.getAttribute("balsum").getString();
					if(result == null) result = "0";             //��ֹ��ָ���쳣
				}
			}	
		}
		
		return result;
	}
	
	//�������δ����������
	public static String getProjectCLBillUnfinished(String contractid) throws Exception
	{
		String result = "";
		if(contractid.equals("") || contractid == null) result="0";
		else{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
			BizObjectQuery boq = bm.createQuery("select v.count(O.serialno) as v.cnt from O where O.BALANCE>0 and contractserialno=:contractid");
			boq.setParameter("contractid",contractid);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
					result = bo.getAttribute("cnt").getString();
					if(result == null) result = "";  
			}	
		}

		return result;
	}
	//�������ͳ��
	public static String getProjectCLBillOver(String contractid,String flag) throws Exception
	{
		String result = ""; 
		if(contractid.equals("") || contractid == null) result="0";
		else{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
			BizObjectQuery boq = bm.createQuery("select v.count(O.serialno) as v.cnt,v.sum(O.BALANCE) as v.allsum "
					+ " from O where O.OVERDUEDAYS>0 and contractserialno=:contractid");
			boq.setParameter("contractid",contractid);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				if(flag.equals("1.0"))
				{
					result = bo.getAttribute("cnt").getString();
					if(result == null) result = "0";  
				}
				if(flag.equals("2.0"))
				{
					result = bo.getAttribute("allsum").getString();
					if(result == null) result = "0";             
				}
			}	
		}
		return result;
	}
	
	//ǷϢ���ͳ��
	public static String getInterBalance(String contractid,String flag) throws Exception
	{
		String result = ""; 
		if(contractid.equals("") || contractid == null) result="0";
		else{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
			BizObjectQuery boq = bm.createQuery("select v.count(O.serialno) as v.cnt,v.sum(O.interestbalance1+O.interestbalance2) as v.allsum "
					+ " from O where (O.interestbalance1>0 or O.interestbalance2>0) and contractserialno=:contractid");
			boq.setParameter("contractid",contractid);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
				if(flag.equals("1.0"))
				{
					result = bo.getAttribute("cnt").getString();
					if(result == null) result = "0";  
				}
				if(flag.equals("2.0"))
				{
					result = bo.getAttribute("allsum").getString();
					if(result == null) result = "0";            
				}
			}	
		}
		return result;
	}
	
	//���ڽ��
	public static String getOverBusinesssum(String contractid) throws Exception
	{
		String result = "";
		if(contractid.equals("") || contractid == null) result="0";
		else{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
			BizObjectQuery boq = bm.createQuery("select v.sum(O.OVERDUEBALANCE) as v.allsum from O where contractserialno=:contractid");
			boq.setParameter("contractid",contractid);
			BizObject bo = boq.getSingleResult(false);
			if(bo != null)
			{
					result = bo.getAttribute("allsum").getString();
					if(result == null) result = "0.00";             
			}	
		}
		return result;
	}

	//���մ������Խ��ͳ�ƣ�
	public static String getCollCont(String serialno) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
		BizObjectQuery boq = bm.createQuery("select v.count(O.serialno) as v.cnt from O "
				+ "where objecttype='jbo.app.BUSINESS_DUEBILL' and objectno=:serialno");
		boq.setParameter("serialno",serialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
				result = bo.getAttribute("cnt").getString();
				if(result == null) result = "0";  
		}	
		return result;
	}
	
	//�������jbo.app.BUSINESS_CONTRACT
	public static String getMaxltvratio(String serialno) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery boq = bm.createQuery("select maxltvratio from O where objecttype='jbo.app.BUSINESS_CONTRACT' and objectno=:serialno");
		boq.setParameter("serialno",serialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
				result = bo.getAttribute("maxltvratio").getString();
				if(result == null) result = "";  
		}	
		return result;
	}
	
	//���ռ������õȼ���������
	public static String getRiskLevel(String serialno,String flag) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.rds.OUTMESSAGE");
		BizObjectQuery boq = bm.createQuery("select O.RISK as v.risk,O.CREDIT as v.credit,O.APPROVE_RESULT as v.approveresult from O "
				+ " where contractno=:serialno");
		boq.setParameter("serialno",serialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			if(flag.equals("1.0"))
			{
				result = bo.getAttribute("risk").getString();
				if(result == null) result = "";             //��ֹ��ָ���쳣
			}
			if(flag.equals("2.0"))
			{
				result = bo.getAttribute("credit").getString();
				if(result == null) result = "";             //��ֹ��ָ���쳣
			}
			if(flag.equals("3.0"))
			{
				result = bo.getAttribute("approveresult").getString();
				if(result == null) result = "";             //��ֹ��ָ���쳣
			}
		}	
		return result;
	}
	
	//��ȥ12�����ۼ�����
	public static String getLast12MonthsOverTerms(String serialno) throws Exception
	{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.rds.INMESSAGE");
		BizObjectQuery boq = bm.createQuery("select LAST12MTOTOVDTIMES from O where cino=:serialno");
		boq.setParameter("serialno",serialno);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
				result = bo.getAttribute("LAST12MTOTOVDTIMES").getString();
				if(result == null) result = "";  
		}	
		return result;
	}
	
	//Ԥ���ź�����jbo.al.RISK_WARNING_SIGNAL
	public static String getSignalName(String signalid,String flag) throws Exception
	{
		String result = "";
		String level = "";
		if(flag.equals("1.0")) level = "1";
		if(flag.equals("2.0")) level = "2";
		if(flag.equals("3.0")) level = "3";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.RISK_WARNING_CONFIG");
		BizObjectQuery boq = bm.createQuery("select SIGNALNAME from O where signalid=:signalid and signallevel=:signallevel");
		boq.setParameter("signalid",signalid);
		boq.setParameter("signallevel",level);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
				result = bo.getAttribute("SIGNALNAME").getString();
				if(result == null) result = ""; 
		}	
		return result;
		
	}
	
	//Ԥ��ʱ��jbo.al.RISK_WARNING_SIGNAL
	public static String getRiskTime(String serialno,String signaltype) throws Exception
	{
		String result = "";
		BizObjectManager bm = null ;
		BizObjectQuery boq = null;
		BizObject bo = null;
		if(signaltype.equals("03"))
		{
			bm = JBOFactory.getBizObjectManager("jbo.al.RISK_WARNING_SIGNAL");
			boq = bm.createQuery("select INPUTDATE from O where serialno=:serialno");
			boq.setParameter("serialno",serialno);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
					result = bo.getAttribute("INPUTDATE").getString();
					if(result == null) result = ""; 
			}	
		}
		/*02��ʾ���ڽ��״̬����ʱinputdate��ʾ���Ԥ��״̬��ʱ�䣬���Ҷ�ΪԤ��״̬��ʱ����Ҫ������ˮ�Ź���RISK_WARNING_OBJECT��,
		 * ���ݹ����ҵ���signalserialno�ٴη��ص�RISK_WARNING_SIGNAL�������Ӧ��inputdateʱ��
		*/
		if(signaltype.equals("02"))
		{
			String signalserialno = "";
			bm = JBOFactory.getBizObjectManager("jbo.al.RISK_WARNING_OBJECT");
			boq = bm.createQuery("select SIGNALSERIALNO from O "
					+ "where OBJECTTYPE='jbo.al.RISK_WARNING_SIGNAL' and OBJECTNO=:serialno");
			boq.setParameter("serialno",serialno);
			bo = boq.getSingleResult(false);
			if(bo != null)
			{
				signalserialno = bo.getAttribute("SIGNALSERIALNO").getString();
				if(signalserialno != null)
				{
					bm = JBOFactory.getBizObjectManager("jbo.al.RISK_WARNING_SIGNAL");
					boq = bm.createQuery("select INPUTDATE from O where serialno=:serialno");
					boq.setParameter("serialno",signalserialno);
					bo = boq.getSingleResult(false);
					if(bo != null)
					{
							result = bo.getAttribute("INPUTDATE").getString();
							if(result == null) result = ""; 
					}	
				}
			}	
		}



		return result;
		
	}
	

	public static String getTransDesc(String transSerialNo)throws Exception{
		String result = "";
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.acct.ACCT_TRANSACTION");
		BizObjectQuery boq = bm.createQuery("select * from O where SerialNo=:SerialNo");
		boq.setParameter("SerialNo",transSerialNo);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			String transCode = bo.getAttribute("TransactionCode").getString();
			String documentObjectType = bo.getAttribute("DocumentObjectType").getString();
			String documentObjectNo = bo.getAttribute("DocumentObjectNo").getString();
			if("0000".equals(transCode))
			{
				BizObjectManager bmt = JBOFactory.getBizObjectManager(documentObjectType);
				BizObjectQuery bmtq = bmt.createQuery("select ChangeLog from O where SerialNo=:SerialNo");
				bmtq.setParameter("SerialNo",documentObjectNo);
				BizObject bot = bmtq.getSingleResult(false);
				if(bot != null)
				{
					result = bot.getAttribute("ChangeLog").getString();
				}
			}
			
		}
		if(result==null)result="";
		
		return result;
	}
	//�ж��Ƿ����¶����������
	public static String getYesOrNoCLType(String serialNo)throws Exception{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery boq = bm.createQuery("O.ObjectNo=:ObjectNo and O.ObjectType='jbo.app.BUSINESS_CONTRACT'");
		boq.setParameter("ObjectNo",serialNo);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			String CLSerialNo = bo.getAttribute("SerialNo").toString();
			BizObjectQuery boclq = bm.createQuery("O.ParentSerialNo=:ParentSerialNo and O.CLType = '0102'");
			boclq.setParameter("ParentSerialNo",CLSerialNo);
			BizObject bocl = boclq.getSingleResult(false);
			if(bocl != null){
				result = "1";
			}
		}else{
			result = "0";
		}
		return result;
	}
	//�ж��Ƿ����¶����������
	public static String getYesOrNoCLType2(String serialNo)throws Exception{
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery boq = bm.createQuery("O.ObjectNo=:ObjectNo and O.ObjectType='jbo.app.BUSINESS_CONTRACT'");
		boq.setParameter("ObjectNo",serialNo);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			String CLSerialNo = bo.getAttribute("SerialNo").toString();
			BizObjectQuery boclq = bm.createQuery("O.ParentSerialNo=:ParentSerialNo and O.CLType in ('0103','0104')");
			boclq.setParameter("ParentSerialNo",CLSerialNo);
			BizObject bocl = boclq.getSingleResult(false);
			if(bocl != null){
				result = "1";
			}
		}else{
			result = "0";
		}
		return result;
	}
	//��ȡ���״̬
	public static String getCLStatus(String serialNo)throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
		BizObjectQuery boq = bm.createQuery("O.ObjectNo=:ObjectNo and O.ObjectType='jbo.app.BUSINESS_CONTRACT'");
		boq.setParameter("ObjectNo",serialNo);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
			String Status = bo.getAttribute("Status").toString();
			return CodeManager.getItemName("CLStatus", Status);
		}
		else return "";
	}
	
	//�Ƿ��˹��϶�ΥԼ
	public static String IsPersonDefault(String serialNo)throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.DEFAULT_RECORD");
		BizObjectQuery boq = bm.createQuery("O.ObjectNo=:ObjectNo and O.ObjectType='jbo.app.BUSINESS_DUEBILL' and O.ApproveOpinion='01' ").setParameter("ObjectNo",serialNo);
		BizObject bo = boq.getSingleResult(false);
		String IsPersonDefault = "";
		if(bo!=null){
			IsPersonDefault = "��";
		}
		return IsPersonDefault;
	}
	//ΥԼ�϶�ʱ��
	public static String DefaultTime(String serialNo)throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.DEFAULT_RECORD");
		BizObjectQuery boq = bm.createQuery("O.ObjectNo=:ObjectNo and O.ObjectType='jbo.app.BUSINESS_DUEBILL' and O.ApproveOpinion='01' Order by SerialNo DESC").setParameter("ObjectNo",serialNo);
		BizObject bo = boq.getSingleResult(false);
		String DefaultTime = "";
		if(bo != null){
			DefaultTime = bo.getAttribute("APPROVEDATE").getString();
			if(DefaultTime == null){
				DefaultTime = "";
			}
		}
		return DefaultTime;
	}
	//ΥԼ�϶�ԭ��
	public static String DefaultReason(String serialNo)throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.DEFAULT_RECORD");
		BizObjectQuery boq = bm.createQuery("O.ObjectNo=:ObjectNo and O.ObjectType='jbo.app.BUSINESS_DUEBILL' and O.ApproveOpinion='01' Order by SerialNo DESC").setParameter("ObjectNo",serialNo);
		BizObject bo = boq.getSingleResult(false);
		String DefaultReason = "";
		if(bo != null){
			String DefaultReasonCode = bo.getAttribute("REASON").getString();
				if(!StringX.isEmpty(DefaultReasonCode)){
				return CodeManager.getItemName("DefaultReason", DefaultReasonCode);
			}
		}
		return DefaultReason;
	}
	
	//����ʱ��
	public static String classifyDate(String serialNo)throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.al.CLASSIFY_RECORD");
		BizObjectQuery boq = bm.createQuery("O.ObjectNo=:ObjectNo and O.ObjectType='jbo.app.BUSINESS_DUEBILL' Order by CLASSIFYDATE DESC").setParameter("ObjectNo",serialNo);
		BizObject bo = boq.getSingleResult(false);
		String classifyDate = "";
		if(bo != null){
			String CLASSIFYDATE = bo.getAttribute("CLASSIFYDATE").getString();
			if(!StringX.isEmpty(CLASSIFYDATE)){
				classifyDate=CLASSIFYDATE;
			}
		}
		return classifyDate;
	}
/*	private static String exeDatabase (String jboname,String ...strings ){
		String result = "";
		BizObjectManager bm = JBOFactory.getBizObjectManager(jboname);
		BizObjectQuery boq = bm.createQuery("select inputdate from O where signalid=:signalid and signallevel=:signallevel");
		boq.setParameter("signalid",signalid);
		//boq.setParameter("signallevel",Integer.parseInt(flag));
		boq.setParameter("signallevel",level);
		BizObject bo = boq.getSingleResult(false);
		if(bo != null)
		{
				result = bo.getAttribute("SIGNALNAME").getString();
				if(result == null) result = ""; 
		}	
		return result;
	}*/
}
