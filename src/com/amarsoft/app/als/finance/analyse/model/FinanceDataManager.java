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
	 * 获取客户最新一期报表
	 * @param CustomerID 客户编号
	 * @return 返回执行结果对象，为空则代表不存在客户的任何报表
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
	 * 获取客户某一期报表的上年同期的报表
	 * @param CustomerFSRecord 基准报表
	 * @return 返回执行结果对象，为空则代表不存在客户的任何报表
	 */
	public CustomerFSRecord getLast1Report(CustomerFSRecord cfs){
		return getLastSerNReport(cfs,-1);
	}
		
	/**
	 * 获取客户某一期报表的上n年同期的报表
	 * @param CustomerFSRecord 基准报表，n(n<0)，上n年
	 * @return 返回执行结果对象，为空则代表不存在客户的任何报表
	 */
	public CustomerFSRecord getLastSerNReport(CustomerFSRecord cfs,int n){
		CustomerFSRecord lr = new CustomerFSRecord();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject o = null;
		
		if(cfs!=null){
			try{
				String baseReportYear = cfs.getReportDate().substring(0,4);//年份
				String baseReportMonth = cfs.getReportDate().substring(4,7);//月份
				String lastSerNReportDate = String.valueOf(Integer.parseInt(baseReportYear)+n)+baseReportMonth;//上年同期
				//优先取同口径、同周期报表
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
	 * 获取客户某一期报表的上n年年报
	 * @param CustomerFSRecord 基准报表，n(n<0)，上n年
	 * @return 返回执行结果对象，为空则代表不存在客户的任何报表
	 */
	public CustomerFSRecord getRelativeYearReport(CustomerFSRecord cfs,int n){
		CustomerFSRecord lr = new CustomerFSRecord();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject o = null;
		
		if(cfs!=null){
			try{
				String baseReportYear = cfs.getReportDate().substring(0,4);//年份
				String yearReportDate = String.valueOf(Integer.parseInt(baseReportYear)+n)+"/12";//上n年年报
				//优先取同口径报表
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
	 * 获取客户最新1期年报
	 * @param CustomerID
	 * @return 返回执行结果对象，为空则代表不存在客户的任何报表
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
	 * 获取客户财务报表某张子表模型号
	 * @param ModelClass,报表类型(子类型)，ModelAbbr，报表描述，如“资产负债表”，“财务简表”
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
	 * 获取客户财务报表某张子表ReportNo
	 * @param ModelNo,子表模型号，FSRecordNo，报表流水号
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
	 * 获取客户某期报表子表所有科目，以List形式返回
	 * @param Unit，显示单位 ModelAbbr，报表描述
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
	 * 获取客户某期报表资产负债表所有科目，按万元以List形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public List getAssetList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"资产负债表","10000");
	}
	
	/**
	 * 获取客户某期报表收支总表或者利润表所有科目，按万元以List形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public List getLossList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"利润表","10000");
	}
	
	/**
	 * 获取客户某期报表现金流量表所有科目，按万元以List形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public List getCashList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"现金流量表(人工)","10000");
	}
	
	/**
	 * 获取客户某期报表简表所有科目，按万元以List形式返回，只适用于企业简表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public List getSimpleList(CustomerFSRecord cfs){
		return getSubjectList(cfs,"财务简表","10000");
	}
	
	/**
	 * 获取客户某期报表财务明细附表的记录流水号
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public String getDetailNo(CustomerFSRecord cfs){
		if(cfs!=null){
			String sModelNo = getModel(cfs.getSubFinanceBelong(),"明细附表");
			return getReportNo(sModelNo,cfs.getRecordNo());
		}else{
			return null;
		}
	}
	
	/**
	 * 获取客户某期报表子表所有科目，以Map形式返回
	 * @param Unit，显示单位 ModelAbbr，报表描述
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
	 * 获取客户某期报表资产负债表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getAssetMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"资产负债表","10000");
	}
	
	/**
	 * 获取客户某期报表收支总表或者利润表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getLossMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"利润表","10000");
	}
	
	/**
	 * 获取客户某期报表现金流量表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getCashMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"现金流量表(人工)","10000");
	}
	
	/**
	 * 获取客户某期报表财务指标表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getGuideMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"财务指标表","10000");
	}
	
	/**
	 * 获取客户某期报表简表所有科目，按万元以Map形式返回，只适用于企业简表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getSimpleMap(CustomerFSRecord cfs){
		return getSubjectMap(cfs,"财务简表","10000");
	}
	
	
	
	/**
	 * 获取最新一期年报期次
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
	 * 判断提供的三年报表是否是连续的
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
	 * 获取客户最新期报表报表类型
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
	 * 提供给授信流程的接口方法，判断客户财务报表是否是正规的一般企业(新旧)财务报表
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
	 * 获取客户的优先报表
	 * 规则：
	 * 优先取年报
	 * 没有年报，取最近一期报表
	 * 报表状态：完成或锁定
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
	 * 以下为新增获取财务数据方法，Map中以科目号作为"键"
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
	 * 获取客户某期报表资产负债表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getAssetIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"资产负债表","10000");
	}
	
	/**
	 * 获取客户某期报表收支总表或者利润表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getLossIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"利润表","10000");
	}
	
	/**
	 * 获取客户某期报表现金流量表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getCashIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"现金流量表(人工)","10000");
	}
	
	/**
	 * 获取客户某期报表财务指标表所有科目，按万元以Map形式返回，只适用于一般企业报表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getGuideIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"财务指标表","10000");
	}
	
	/**
	 * 获取客户某期报表简表所有科目，按万元以Map形式返回，只适用于企业简表
	 * @param Unit，显示单位 ModelAbbr，报表描述
	 * @return
	 */
	public Map getSimpleIDMap(CustomerFSRecord cfs){
		return getSubjectIDMap(cfs,"财务简表","10000");
	}
	
	/**
	 * 获取客户某期报表所有科目，按万元以Map形式返回
	 * @param Unit，显示单位
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
	 * 获取客户某期报表所有科目，按万元以Map形式返回
	 * @param Unit，显示单位
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
