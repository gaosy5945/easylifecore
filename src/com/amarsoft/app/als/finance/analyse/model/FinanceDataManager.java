package com.amarsoft.app.als.finance.analyse.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;

public class FinanceDataManager implements Serializable{

	private static final long serialVersionUID = 1L;
	
	/**
	 * ��ȡ�ͻ�����һ�ڱ���
	 * @param CustomerID �ͻ����
	 * @return ����ִ�н������Ϊ����������ڿͻ����κα���
	 */
	public CustomerFSRecord getNewestReport(String sCustomerID){
		try{
			BizObjectManager m = null;
			BizObjectQuery q = null;
			BizObject o = null;
			CustomerFSRecord cfs = new CustomerFSRecord();
			
			m = getCFSManager();
	        q = m.createQuery("customerID=:customerID and reportStatus in('1','02') "
							+ "order by reportDate desc,reportPeriod desc,reportScope asc,auditFlag asc");
			q.setParameter("customerID", sCustomerID);
	        o= q.getSingleResult();
	        if(o!=null){
	        	cfs.setValue(o);
	            return cfs;
	        }
	        else{
	        	return null;
	        }
	        
		  }catch(Exception e){
			     e.printStackTrace();
			     return null;
		  }
	}
	
	/**
	 * ��ȡ�ͻ�ĳһ�ڱ��������ͬ�ڵı���
	 * @param CustomerFSRecord ��׼����
	 * @return ����ִ�н������Ϊ����������ڿͻ����κα���
	 */
	public CustomerFSRecord getLast1Report(CustomerFSRecord cfs){
		return getLastSerNReport(cfs,-1);
	}
		
	/**
	 * ��ȡ�ͻ�ĳһ�ڱ������n��ͬ�ڵı���
	 * @param CustomerFSRecord ��׼����n(n<0)����n��
	 * @return ����ִ�н������Ϊ����������ڿͻ����κα���
	 */
	public CustomerFSRecord getLastSerNReport(CustomerFSRecord cfs,int n){
		CustomerFSRecord lr = new CustomerFSRecord();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject o = null;
		
		if(cfs!=null){
			try{
				String baseReportYear = cfs.getReportDate().substring(0,4);//���
				String baseReportMonth = cfs.getReportDate().substring(4,7);//�·�
				String lastSerNReportDate = String.valueOf(Integer.parseInt(baseReportYear)+n)+baseReportMonth;//����ͬ��
				//����ȡͬ�ھ���ͬ���ڱ���
				m = getCFSManager();
				q = m.createQuery("customerID=:customerID and reportStatus in('1','02') "
        		        +"and reportDate=:reportDate and reportPeriod=:reportPeriod "
        		        +"and reportScope=:reportScope order by auditFlag asc");
				
				q.setParameter("customerID", cfs.getCustomerID());
		        q.setParameter("reportDate", lastSerNReportDate);
		        q.setParameter("reportPeriod",cfs.getReportPeriod());
		        q.setParameter("reportScope", cfs.getReportScope());
		        
		        o=q.getSingleResult();
		        if(o!=null){
		        	lr.setValue(o);
		        }else{
		        	/*q = m.createQuery("customerID=:customerID and reportStatus in('1','02') and reportDate=:reportDate "
  	                      +"order by reportPeriod desc,reportScope asc,auditFlag asc");
			      	q.setParameter("customerID", cfs.getCustomerID());
			      	q.setParameter("reportDate", lastSerNReportDate);
			      	o=q.getSingleResult();
			      	
			      	if(o!=null){
			      		lr.setValue(o);
			      	}
			      	else{
			      		return null;
			      	}*/
		        	return null;
		        }
				
				return lr;
			}catch(Exception e){
				e.printStackTrace();
			    return null;
			}	
		}else{
			return null;
		}		
	}
    
	
	/**
	 * ��ȡ�ͻ�ĳһ�ڱ������n���걨
	 * @param CustomerFSRecord ��׼����n(n<0)����n��
	 * @return ����ִ�н������Ϊ����������ڿͻ����κα���
	 */
	public CustomerFSRecord getRelativeYearReport(CustomerFSRecord cfs,int n){
		CustomerFSRecord lr = new CustomerFSRecord();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject o = null;
		
		if(cfs!=null){
			try{
				String baseReportYear = cfs.getReportDate().substring(0,4);//���
				String yearReportDate = String.valueOf(Integer.parseInt(baseReportYear)+n)+"/12";//��n���걨
				//����ȡͬ�ھ�����
				m = getCFSManager();
				q = m.createQuery("customerID=:customerID and reportStatus in('1','02') and reportPeriod='04' and "
									+"reportDate=:reportDate and reportScope=:reportScope "
									+ "order by auditFlag asc");
				q.setParameter("customerID", cfs.getCustomerID());
				q.setParameter("reportDate", yearReportDate);
				q.setParameter("reportScope", cfs.getReportScope());
				o=q.getSingleResult();
		        if(o != null){
		        	lr.setValue(o);
		        }else{
		        	/*q = m.createQuery("customerID=:customerID and reportStatus in('1','02') and reportPeriod='04' and "
									+"reportDate=:reportDate order by ReportScope asc,auditFlag asc");
		      	q.setParameter("customerID", cfs.getCustomerID());
				q.setParameter("reportDate", yearReportDate);
		      	o=q.getSingleResult();
		      	
		      	if(o!=null){
		      		lr.setValue(o);
		      	}
		      	else{
		      		return null;
		      	}*/
		        	return null;
		        }
		        return lr;
			
			}catch(Exception e){
				e.printStackTrace();
			    return null;
			}
		}else{
			return null;
		}
	}
	
	/**
	 * ��ȡ�ͻ�����1���걨
	 * @param CustomerID
	 * @return ����ִ�н������Ϊ����������ڿͻ����κα���
	 */
	public CustomerFSRecord getNewYearReport(String sCustomerID){
		CustomerFSRecord cfs = new CustomerFSRecord();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject o = null;
		
		try{
			m = getCFSManager();
	        q = m.createQuery("customerID=:customerID and reportStatus in('1','02') "
							+ "and ReportPeriod = '04' order by reportDate desc,reportScope asc,auditFlag asc");
			q.setParameter("customerID", sCustomerID);
	        o= q.getSingleResult();
	        if(o!=null){
	        	cfs.setValue(o);
	            return cfs;
	        }
	        else{
	        	return null;
	        }
		
		}catch(Exception e){
			e.printStackTrace();
		    return null;
		}
	}
	
	/**
	 * ��ȡ�ͻ����񱨱�ĳ���ӱ�ģ�ͺ�
	 * @param ModelClass,��������(������)��ModelAbbr�������������硰�ʲ���ծ������������
	 * @return String
	 */
	protected String getModel(String sModelClass,String sModelAbbr){
		try{
			BizObjectManager m = null;
			BizObject o = null;
			BizObjectQuery q = null;
			String sModelNo = "";
			
			m = JBOFactory.getFactory().getManager("jbo.finasys.REPORT_CATALOG");
	        q = m.createQuery("select modelNo from o where modelClass=:modelClass and modelAbbr=:modelAbbr");
	        q.setParameter("modelClass", sModelClass);
	        q.setParameter("modelAbbr", sModelAbbr);
	        o=q.getSingleResult();
	        if(o!=null){
	        	sModelNo = o.getAttribute("modelNo").getString();
	        }
	        return sModelNo;
	        
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * ��ȡ�ͻ����񱨱�ĳ���ӱ�ReportNo
	 * @param ModelNo,�ӱ�ģ�ͺţ�FSRecordNo��������ˮ��
	 * @return String
	 */
	protected String getReportNo(String sModelNo,String sFSRecordNo){
		try{
			BizObjectManager m = null;
			BizObject o = null;
			BizObjectQuery q = null;
			String sReportNo = "";
			
			m = getRRManager();
			q = m.createQuery("select reportNo from o where fsRecordNo=:fsRecordNo and modelNo=:modelNo");
			q.setParameter("fsRecordNo", sFSRecordNo);
			q.setParameter("modelNo", sModelNo);
			o=q.getSingleResult();
			if(o!=null){
				sReportNo=o.getAttribute("reportNo").getString();
			}
			return sReportNo;
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ӱ����п�Ŀ����List��ʽ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public List getSubjectList(CustomerFSRecord cfs,String sModelAbbr,String sUnit){
		List <ReportSubject>  SubjectList = new ArrayList <ReportSubject>();
		try{
			if(cfs!=null){
				BizObjectManager m = null;
				BizObject o = null;
				BizObjectQuery q = null;
				
				String sModelNo = this.getModel(cfs.getSubFinanceBelong(), sModelAbbr);
				String sReportNo = getReportNo(sModelNo,cfs.getRecordNo());
				m = this.getRDManager();
				q = m.createQuery("ReportNo=:ReportNo and RowSubject<>'1000' order by DisplayOrder");
				q.setParameter("ReportNo", sReportNo);
				
				List ls = q.getResultList();
				for(int i=0;i<=ls.size()-1;i++){
					BizObject bo = (BizObject)ls.get(i);
					ReportSubject rs = new ReportSubject();
					rs.setValueDisplay(bo,sUnit);
					SubjectList.add(rs);
				}
				return SubjectList;
				
			}else{
				return null;
			}
			
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ʲ���ծ�����п�Ŀ������Ԫ��List��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public List getAssetList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"�ʲ���ծ��","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ�����֧�ܱ������������п�Ŀ������Ԫ��List��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public List getLossList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"�����","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ֽ����������п�Ŀ������Ԫ��List��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public List getCashList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"�ֽ�������(�˹�)","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ��������п�Ŀ������Ԫ��List��ʽ���أ�ֻ��������ҵ���
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public List getSimpleList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"������","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ��������ϸ����ļ�¼��ˮ��
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public String getDetailNo(CustomerFSRecord cfs){
		if(cfs!=null){
			String sModelNo = getModel(cfs.getSubFinanceBelong(),"��ϸ����");
			return getReportNo(sModelNo,cfs.getRecordNo());
		}else{
			return null;
		}
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ӱ����п�Ŀ����Map��ʽ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getSubjectMap(CustomerFSRecord cfs,String sModelAbbr,String sUnit){
		Map<String,ReportSubject> subjectMap = new HashMap();
		try{
			if(cfs!=null){
				BizObjectManager m = null;
				BizObject o = null;
				BizObjectQuery q = null;
				
				String sModelNo = this.getModel(cfs.getSubFinanceBelong(), sModelAbbr);
				String sReportNo = getReportNo(sModelNo,cfs.getRecordNo());
				m = this.getRDManager();
				q = m.createQuery("ReportNo=:ReportNo and RowSubject<>'1000' order by DisplayOrder");
				q.setParameter("ReportNo", sReportNo);
				
				List ls = q.getResultList();
				for(int i=0;i<=ls.size()-1;i++){
					BizObject bo = (BizObject)ls.get(i);
					ReportSubject rs = new ReportSubject();
					rs.setValueDisplay(bo,sUnit);
					subjectMap.put(rs.getRowName().trim(),rs);
				}
				return subjectMap;
				
			}else{
				return null;
			}
			
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ʲ���ծ�����п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getAssetMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"�ʲ���ծ��","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ�����֧�ܱ������������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getLossMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"�����","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ֽ����������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getCashMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"�ֽ�������(�˹�)","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ������ָ������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getGuideMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"����ָ���","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ��������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ��������ҵ���
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getSimpleMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"������","10000");
	}
	
	
	
	/**
	 * ��ȡ����һ���걨�ڴ�
	 * @return
	 * @throws Exception
	 */
	public String getNewestYearReportDate(String sCustomerID){
		try{
			String newestYearReportDate="";
			CustomerFSRecord cfsr=getNewYearReport(sCustomerID);
			if(cfsr!=null){
				newestYearReportDate=cfsr.getReportDate();
			}
			return newestYearReportDate;
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * �ж��ṩ�����걨���Ƿ���������
	 * @return
	 * @throws Exception
	 */
	public String isLianXu(String sCustomerID){
	try{			
//		CustomerFSRecord cfs = getNewestReport(sCustomerID);
		CustomerFSRecord lastRecord = getNewYearReport(sCustomerID);
		CustomerFSRecord lastRecord1 = getRelativeYearReport(lastRecord,-1);
		CustomerFSRecord lastRecord2 = getRelativeYearReport(lastRecord,-2);
		if(lastRecord!=null && lastRecord1!=null && lastRecord2!=null){
			return "1";
		}else{
			return "2";
		}
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * ��ȡ�ͻ������ڱ���������
	 * @return
	 * @throws Exception
	 */
	protected String getNewFinanceBelong(String customerID){
		CustomerFSRecord  cfs  = getNewestReport(customerID);
		if(cfs==null){
			return null;
		}else{
			return cfs.getFinanceBelong();
		}
		
	}
	
	/**
	 * �ṩ���������̵Ľӿڷ������жϿͻ����񱨱��Ƿ��������һ����ҵ(�¾�)���񱨱�
	 */
	public String supplyEntReport(String customerID){
		String financeBelong = getNewFinanceBelong(customerID);
		if(financeBelong==null){
			return FinanceReportConst.FINANCEBELONG_NULL;
		}else if("010".equals(financeBelong)||"020".equals(financeBelong)||"160".equals(financeBelong)){
			return FinanceReportConst.FINANCEBELONG_ENT;
		}else{
			return FinanceReportConst.FINANCEBELONG_OTHER;
		}	
	}
	
	/**
	 * ��ȡ�ͻ������ȱ���
	 * ����
	 * ����ȡ�걨
	 * û���걨��ȡ���һ�ڱ���
	 * ����״̬����ɻ�����
	 */
	public CustomerFSRecord getPriorityCFS(String customerID){
		CustomerFSRecord cfs = null;
		cfs = getNewYearReport(customerID);
		if(cfs!=null){
			return cfs;
		}else{
			cfs = getNewestReport(customerID);
			return cfs;
		}
	}
	
	/**
	 * ����Ϊ������ȡ�������ݷ�����Map���Կ�Ŀ����Ϊ"��"
	 */
	public Map getSubjectIDMap(CustomerFSRecord cfs,String sModelAbbr,String sUnit){
		Map<String,ReportSubject> subjectMap = new HashMap();
		try{
			if(cfs!=null){
				BizObjectManager m = null;
				BizObject o = null;
				BizObjectQuery q = null;
				
				String sModelNo = this.getModel(cfs.getSubFinanceBelong(), sModelAbbr);
				String sReportNo = getReportNo(sModelNo,cfs.getRecordNo());
				m = this.getRDManager();
				q = m.createQuery("ReportNo=:ReportNo and RowSubject<>'1000' order by DisplayOrder");
				q.setParameter("ReportNo", sReportNo);
				
				List ls = q.getResultList();
				for(int i=0;i<=ls.size()-1;i++){
					BizObject bo = (BizObject)ls.get(i);
					ReportSubject rs = new ReportSubject();
					rs.setValueDisplay(bo,sUnit);
					subjectMap.put(rs.getRowSubject().trim(),rs);
				}
				return subjectMap;
				
			}else{
				return null;
			}
			
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ʲ���ծ�����п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getAssetIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"�ʲ���ծ��","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ�����֧�ܱ������������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getLossIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"�����","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ����ֽ����������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getCashIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"�ֽ�������(�˹�)","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ������ָ������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ������һ����ҵ����
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getGuideIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"����ָ���","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ��������п�Ŀ������Ԫ��Map��ʽ���أ�ֻ��������ҵ���
	 * @param Unit����ʾ��λ ModelAbbr����������
	 * @return
	 */
	public Map getSimpleIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"������","10000");
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ������п�Ŀ������Ԫ��Map��ʽ����
	 * @param Unit����ʾ��λ
	 * @return
	 */
	public Map getAllSubjectMap(CustomerFSRecord cfs,String sUnit){
		Map<String,ReportSubject> subjectMap = new HashMap();
		try{
			if(cfs!=null){
				BizObjectManager m = null;
				BizObject o = null;
				BizObjectQuery q = null;
				m = this.getCFSManager();
				
				String sSql = "SELECT RD.RowNo as v.RowNo,RD.DisplayOrder as v.DisplayOrder,RD.RowSubject as v.RowSubject,RD.RowName as v.RowName,RD.RowDimType as v.RowDimType,RD.Col2Value as v.Col2Value,RD.Col1Value as v.Col1Value FROM"+
					          " o,jbo.finasys.REPORT_RECORD RR,jbo.finasys.REPORT_DATA RD,jbo.finasys.REPORT_CATALOG RC,jbo.finasys.REPORT_MODEL RM"+
					          " where o.RecordNo = RR.FSRecordNo and RR.ReportNo = RD.ReportNo and o.RecordNo =:RecordNo and"+
					          " o.SubFinanceBelong = RC.ModelClass and RC.ModelNo = RM.ModelNo and RM.ModelNo = RR.ModelNo and"+
					          " RM.RowSubject = RD.RowSubject and RD.RowSubject <> '1000' and RC.Attribute2 in ('010','020','030','060')";
				q = m.createQuery(sSql);
				q.setParameter("RecordNo", cfs.getRecordNo());
				
				List ls = q.getResultList();
				for(int i=0;i<=ls.size()-1;i++){
					BizObject bo = (BizObject)ls.get(i);
					ReportSubject rs = new ReportSubject();
					rs.setValueDisplay(bo,sUnit);
					subjectMap.put(rs.getRowSubject().trim(),rs);
				}
				return subjectMap;
				
			}else{
				return null;
			}
			
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * ��ȡ�ͻ�ĳ�ڱ������п�Ŀ������Ԫ��Map��ʽ����
	 * @param Unit����ʾ��λ
	 * @return
	 */
	public Map getAllSubject(CustomerFSRecord cfs){
		return getAllSubjectMap(cfs,"10000");
	}
	
	public BizObjectManager getCFSManager() throws Exception{
		return JBOFactory.getFactory().getManager("jbo.finasys.CUSTOMER_FSRECORD");
	}
	
	public BizObjectManager getRRManager() throws Exception{
		return JBOFactory.getFactory().getManager("jbo.finasys.REPORT_RECORD");
	}
	
	public BizObjectManager getRDManager() throws Exception{
		return JBOFactory.getFactory().getManager("jbo.finasys.REPORT_DATA");
	}
}
