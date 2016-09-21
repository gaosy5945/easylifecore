package com.amarsoft.app.als.finance.analyse.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.manage.CodeManager;

public class FinanceDetailManager implements Serializable {
	private static final long serialVersionUID = 1L;
	
	/**
	 * 从Code_library中获得对应条目信息
	 * @param s为条目名称
	 * @return
	 */
	protected BizObject getDetailMsg(String s){
		BizObjectManager m = null;
		BizObject o = null;
		BizObjectQuery q = null;
		try {
			m = getCLManager();
			q = m.createQuery("codeno='SubjectIndexDetail' and isinuse = '1' and itemName=:itemName").setParameter("itemName", s);
			o = q.getSingleResult();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(o != null) {
			return o;
		}else{
			return null;
		}
	}
	
	/**
	 * 获取银行结算明细贷方发生额加和运算
	 */
	public double sumSettleDetail(String sReportNo)throws Exception{
		double result = 0.0;
		List <FinanceDetailRcv> before = getDetailByReportNo(sReportNo,"银行结算明细");
		List <FinanceDetailRcv> after = getDetailFilter(before,"1");
		
		return sumDetail(after);
	}
	
	/**
	 * 对财务明细各记录进行加和运算
	 */
	public double sumDetail(List<FinanceDetailRcv> ls) throws Exception{
		double result = 0.0;
		for(int i=0;i<ls.size();i++){
			result+=((FinanceDetailRcv)ls.get(i)).getAmount();
		}
		return result;
	}
	
	/**
	 * 按DataType对财务明细各记录列表进行过滤，返回过滤后列表
	 */
	public List getDetailFilter(List<FinanceDetailRcv> before,String filter) throws Exception{
		List <FinanceDetailRcv>  after = new ArrayList <FinanceDetailRcv>();
		if(filter==null||"".equals(filter)) return before;
		for(int i=0;i<before.size();i++){
			String sType = ((FinanceDetailRcv)before.get(i)).getDataType();
			if(filter.equals(sType)){
				after.add((FinanceDetailRcv)before.get(i));
			}
		}
		return after;
	}
	
	/**
	 * 生成SQL字串
	 */
	public String getQuerySQL(String detailName){
		String sql = null;
		if("应付帐款".equals(detailName)||"应付账款".equals(detailName)){
			sql = "ReportNo=:reportNo and PAYTYPE='01'";
		}else if("其他应付帐款".equals(detailName)||"其他应付账款".equals(detailName)||"其它应付帐款".equals(detailName)||"其它应付账款".equals(detailName)){
			sql = "ReportNo=:reportNo and PAYTYPE='02'";
		}else if("应收帐款".equals(detailName)||"应收账款".equals(detailName)){
			sql = "ReportNo=:reportNo and RECEIVETYPE='01'";
		}else if("其他应收帐款".equals(detailName)||"其他应收账款".equals(detailName)||"其它应收帐款".equals(detailName)||"其它应收账款".equals(detailName)){
			sql = "ReportNo=:reportNo and RECEIVETYPE='02'";
		}else{
			sql = "ReportNo=:reportNo";
		}
		return sql;
	}
	
	/**
	 * 根据ReportNo获取财务明细表中某科目信息，并以List形式返回
	 * @param detailName要查询的科目名称
	 * @return
	 */
	public List getDetailByReportNo(String sReportNo,String detailName) throws Exception{
		List <FinanceDetailRcv>  RcvList = new ArrayList <FinanceDetailRcv>();
		BizObject o = null;
		BizObjectManager m = null;
		BizObjectQuery q = null;
		String sql = null;
		
		o = getDetailMsg(detailName);
		String itemDescribe = o.getAttribute("itemDescribe").getString();//jbo
		String[] attributes = o.getAttribute("itemAttribute").getString().split("@");//明细对象构造描述
		m = getDetailManager(itemDescribe);
		
		sql = getQuerySQL(detailName);
		
		q = m.createQuery(sql).setParameter("ReportNo", sReportNo);
		List ls  = q.getResultList();
		for(int i=0;i<ls.size();i++){
			BizObject bo = (BizObject)ls.get(i);
			String dataType = bo.getAttribute(attributes[0]).getString();
			String currency = bo.getAttribute(attributes[1]).getString();
			double amount = bo.getAttribute(attributes[2]).getDouble();
			String dataName = bo.getAttribute(attributes[3]).getString();
			
			FinanceDetailRcv rcv = new FinanceDetailRcv();
			rcv.setDataType(dataType);
			rcv.setCurrency(currency);
			rcv.setAmount(amount);
			rcv.setDataName(dataName);
			RcvList.add(rcv);
		}
		
		return RcvList;
	}
	
	/**
	 * 获取财务明细表中某科目信息，并以List形式返回
	 * @param cfs某期报表
	 * @param detailName要查询的科目名称
	 * @return
	 */
	public List getDetailData(CustomerFSRecord cfs,String detailName){
		List <FinanceDetailRcv>  RcvList = new ArrayList <FinanceDetailRcv>();
		BizObjectManager m = null;
		BizObject o = null;
		BizObjectQuery q = null;
		String sql = "";
		o = getDetailMsg(detailName);
		
		sql = getQuerySQL(detailName);
		
		FinanceDataManager financedata = new FinanceDataManager();
		String reportNo = financedata.getDetailNo(cfs);
		try {
			if(o != null){
				String itemDescribe = o.getAttribute("itemDescribe").getString();
				String sattributes = o.getAttribute("itemAttribute").getString();
				String[] attributes = sattributes.split("@");
				String types = o.getAttribute("Attribute5").getString();
				m = getDetailManager(itemDescribe);
				q = m.createQuery(sql).setParameter("reportNo", reportNo);
				List<BizObject> biz = q.getResultList();
				if(biz.size()>0){
					for(int i=0;i<biz.size();i++){
						BizObject bb = biz.get(i);
						String dataType = bb.getAttribute(attributes[0]).getString();
						String currency = bb.getAttribute(attributes[1]).getString();
						double amount = bb.getAttribute(attributes[2]).getDouble();
						String dataName = bb.getAttribute(attributes[3]).getString();
						FinanceDetailRcv rcv = new FinanceDetailRcv();
						if(types == null){
							rcv.setDataType(dataType);
							rcv.setCurrency(CodeManager.getItemName("Currency", currency));
							rcv.setAmount(amount);
							rcv.setDataName(dataName);
							RcvList.add(rcv);
						}else{
							rcv.setDataType(CodeManager.getItemName(types, dataType));
							rcv.setCurrency(CodeManager.getItemName("Currency", currency));
							rcv.setDataName(dataName);
							rcv.setAmount(amount);
							RcvList.add(rcv);
						}
					}
				}
				return RcvList;
			}else {
				return null;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public BizObjectManager getCLManager() throws Exception{
		return JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
	}
	
	public BizObjectManager getDetailManager(String s) throws Exception{
		return JBOFactory.getFactory().getManager(s);
	}
}
