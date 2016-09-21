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
	 * ��Code_library�л�ö�Ӧ��Ŀ��Ϣ
	 * @param sΪ��Ŀ����
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
	 * ��ȡ���н�����ϸ����������Ӻ�����
	 */
	public double sumSettleDetail(String sReportNo)throws Exception{
		double result = 0.0;
		List <FinanceDetailRcv> before = getDetailByReportNo(sReportNo,"���н�����ϸ");
		List <FinanceDetailRcv> after = getDetailFilter(before,"1");
		
		return sumDetail(after);
	}
	
	/**
	 * �Բ�����ϸ����¼���мӺ�����
	 */
	public double sumDetail(List<FinanceDetailRcv> ls) throws Exception{
		double result = 0.0;
		for(int i=0;i<ls.size();i++){
			result+=((FinanceDetailRcv)ls.get(i)).getAmount();
		}
		return result;
	}
	
	/**
	 * ��DataType�Բ�����ϸ����¼�б���й��ˣ����ع��˺��б�
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
	 * ����SQL�ִ�
	 */
	public String getQuerySQL(String detailName){
		String sql = null;
		if("Ӧ���ʿ�".equals(detailName)||"Ӧ���˿�".equals(detailName)){
			sql = "ReportNo=:reportNo and PAYTYPE='01'";
		}else if("����Ӧ���ʿ�".equals(detailName)||"����Ӧ���˿�".equals(detailName)||"����Ӧ���ʿ�".equals(detailName)||"����Ӧ���˿�".equals(detailName)){
			sql = "ReportNo=:reportNo and PAYTYPE='02'";
		}else if("Ӧ���ʿ�".equals(detailName)||"Ӧ���˿�".equals(detailName)){
			sql = "ReportNo=:reportNo and RECEIVETYPE='01'";
		}else if("����Ӧ���ʿ�".equals(detailName)||"����Ӧ���˿�".equals(detailName)||"����Ӧ���ʿ�".equals(detailName)||"����Ӧ���˿�".equals(detailName)){
			sql = "ReportNo=:reportNo and RECEIVETYPE='02'";
		}else{
			sql = "ReportNo=:reportNo";
		}
		return sql;
	}
	
	/**
	 * ����ReportNo��ȡ������ϸ����ĳ��Ŀ��Ϣ������List��ʽ����
	 * @param detailNameҪ��ѯ�Ŀ�Ŀ����
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
		String[] attributes = o.getAttribute("itemAttribute").getString().split("@");//��ϸ����������
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
	 * ��ȡ������ϸ����ĳ��Ŀ��Ϣ������List��ʽ����
	 * @param cfsĳ�ڱ���
	 * @param detailNameҪ��ѯ�Ŀ�Ŀ����
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
