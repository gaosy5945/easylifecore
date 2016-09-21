package com.amarsoft.app.check.apply;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;

/**
 * ��ϻ��ʽУ��
 * @author bhxiao
 * @since 2015/04/04
 */
public class ApplyRPTSegmentCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
			for(BusinessObject ba:baList)
			{
				String rptTermID = ba.getString("RptTermID");
				double businesssum = ba.getDouble("BusinessSum");
				int businessterm = ba.getInt("BusinessTerm");
				int businesstermDay = ba.getInt("BusinessTermDay");
				if("RPT-06".equals(rptTermID)){
					
					//1���ж�����¼��ķֶλ��ʽ��Ϣ¼�����
					String selectRPTSql = " objectno=:ObjectNo and objecttype=:ObjectType ";
					List<BusinessObject> rptList = bom.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", selectRPTSql, "ObjectNo", ba.getString("SerialNo"),"ObjectType", "jbo.app.BUSINESS_APPLY");
					if(rptList==null||rptList.size()==0){
						this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ����δ¼��ֶεĽ׶λ�����Ϣ��");
					}else{
						if(rptList.size()<2||rptList.size()>8){
							this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ������ϻ��ʽ�£�����Ӧ����2���׶Σ���������8���׶Σ�");
						}
						int segendTermTmp = 0;
						double businessSumTmp = 0d;
						String segRPTTermIDTmp = "";
						for(int i=0;i<rptList.size();i++){
							BusinessObject rptInfo = rptList.get(i);
							
							double segRptAmount = rptInfo.getDouble("SegRPTAmount");
							
							int segEndTerm = rptInfo.getInt("SEGToStage");
							if(segendTermTmp == 0){
								segendTermTmp = segEndTerm;
							}else{
								if(segEndTerm>segendTermTmp)
									segendTermTmp = segEndTerm;
							}
							
							if(segEndTerm<=0){
								this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ����{"+i+"}���ֶλ�����Ϣ�������ڴ�С�ڻ����0��");
							}
							
							String segRptTermID = rptInfo.getString("SEGRPTTermID");
							if(segRptTermID==null||segRptTermID.length()==0){
								this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ����{"+i+"}���ֶλ�����Ϣ�����ʽ¼�벻��Ϊ�գ�");
							}
							if("5".equals(segRptTermID)){
								if(segRPTTermIDTmp==null||segRPTTermIDTmp.length()==0){
									segRPTTermIDTmp = segRptTermID;
								}
								if(segRptAmount<=0d){
									this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ����{"+i+"}���ֶλ�����Ϣ�����ʽΪ���̶�����ʱ���ֶ���Ϣ�С��̶�����С�ڻ����0��");
								}
							}
							
							if(!"1".equals(segRptTermID)&&!"2".equals(segRptTermID)){
								businessSumTmp += segRptAmount;
							}
							
						}
						
						for(BusinessObject o:rptList){
							String segRptTermID = o.getString("SEGRPTTermID");
							if(segRPTTermIDTmp!=null&&segRPTTermIDTmp.length()>0
								&&!"5".equals(segRptTermID)&&!"3".equals(segRptTermID)){
								this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ������ֶλ�����Ϣ���ڡ��̶����𡱷�ʽ������Ͻ������еķ�ʽ�������ǡ��̶�����ʽ�����ߡ��ִθ�Ϣ��ʽ����");
								break;
							}
						}
						
						if(businesssum!=businessSumTmp&&segRPTTermIDTmp!=null&&segRPTTermIDTmp.length()>0){
							this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ���ֶλ�����Ϣ�����̶������ܺͱ�����ڴ��������");
						}
						
						if((businesstermDay<=0&&businessterm!=segendTermTmp)||(businesstermDay>0&&businessterm!=(segendTermTmp+1))){
							this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ���ֶλ�����Ϣ����󡰽����ڴΡ�������ڴ����������ޣ�");
						}
					}
					
					//2���жϷֶλ��������Ϣ�����һ�ڵ�¼�����
					String selectRPTSql2 = " objectno=:ObjectNo and objecttype=:ObjectType order by SEGToStage desc ";
					List<BusinessObject> rptList2 = bom.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", selectRPTSql2, "ObjectNo", ba.getString("SerialNo"),"ObjectType", "jbo.app.BUSINESS_APPLY");
					if(rptList2!=null&&rptList2.size()>0){
						BusinessObject endRptInfo = rptList2.get(0);
						String segRptTermID = endRptInfo.getString("SEGRPTTermID");
						if("3".equals(segRptTermID)){
							this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ���ֶλ�����Ϣ�����ִθ�Ϣ��������Ϊ���һ�׶λ��ʽ��");
						}
						
						double segRptAmount = endRptInfo.getDouble("SegRPTAmount");
						if("4".equals(segRptTermID)&&segRptAmount<=0d){
							this.putMsg("����{"+ba.getString("contractartificialno")+"},¼��Ļ��ʽΪ��ϻ���ֶλ�����Ϣ�����һ�׶ε����һ�ڻ��ʽ��ѡ��һ�λ���ʱ��,���һ������׶εġ��̶����𡱱������0��");
						}
					}
				}
			}
		}
		
		if(messageSize() > 0){
			this.setPass(false);
		}else{
			this.setPass(true);
		}
		return null;
	}
}
