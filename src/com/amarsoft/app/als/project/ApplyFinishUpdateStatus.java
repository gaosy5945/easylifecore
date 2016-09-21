package com.amarsoft.app.als.project;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.docmanage.action.DocSelectChangeName;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class ApplyFinishUpdateStatus {
	private String serialNo;//��Ŀ����ˮ��
	private String flowStatus;//��ǰ����״̬
	private String userID;
	private String orgID;
	private String taskSerialNo;//��Ŀ����ˮ��
	
	public String getTaskSerialNo() {
		return taskSerialNo;
	}

	public void setTaskSerialNo(String taskSerialNo) {
		this.taskSerialNo = taskSerialNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}

	public String getFlowStatus() {
		return flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public void lastFinishApprove(JBOTransaction tx) throws Exception{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
		tx.join(bm);
		BusinessObjectManager bomTask = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> taskList = bomTask.loadBusinessObjects("jbo.flow.FLOW_TASK", "TaskSerialNo=:TaskSerialNo","TaskSerialNo", taskSerialNo);
		if(taskList==null||taskSerialNo.isEmpty()) return;
		if("3".equals(this.flowStatus) && taskList.get(0).getAttribute("PHASEACTIONTYPE").getString().equals("01")){	
			bm.createQuery("UPDATE O SET STATUS =:STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO = :SERIALNO")
			.setParameter("STATUS", "13").setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", serialNo).executeUpdate();
			
			//����agreement�����serialno��ŶԱȣ������ͬ��֤���Ǳ�����룬�ڱ����ɺ����׼��������Ŀ״̬ΪʧЧ
			BizObjectQuery qA = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", serialNo);
			BizObject prA = qA.getSingleResult(false);
			String  AgreeMentNo = "";
			String  EffectDate = "";
			String  ExpiryDate = "";
			if(prA!=null)
			{
				AgreeMentNo = prA.getAttribute("AGREEMENTNO").getString();
				EffectDate = prA.getAttribute("EFFECTDATE").getString();
				ExpiryDate = prA.getAttribute("EXPIRYDATE").getString();
				if(!serialNo.equals(AgreeMentNo)){
					BizObjectManager bmPR = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
					tx.join(bmPR);
					BizObjectQuery PR = bmPR.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType='jbo.prj.PRJ_BASIC_INFO' and RelativeType='0301'").setParameter("ProjectSerialNo", serialNo);
					BizObject PPR = PR.getSingleResult(false);
					
					String PBIOldSerialNo = PPR.getAttribute("ObjectNo").toString();
					//�����ǰ����Ŀ״̬��Ϊ�ѱ��
					bm.createQuery("UPDATE O SET STATUS=:STATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO =:SERIALNO")
						.setParameter("STATUS", "17").setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", PBIOldSerialNo).executeUpdate();
				
					//�����ǰ�Ĺ�ģ�����Ϊ��ʧЧ
					BizObjectManager tableCL = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
					tx.join(tableCL);
					
					BizObjectQuery qGMCL = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is null")
							.setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO").setParameter("ObjectNo", PBIOldSerialNo);
					BizObject prGMCL = qGMCL.getSingleResult(false);
					String GMCLOldSerialNo="";
					if(prGMCL != null){
						GMCLOldSerialNo = prGMCL.getAttribute("SerialNo").getString();
						//���¹�ģ�����״̬ΪʧЧ
						tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
							.setParameter("STATUS", "50").setParameter("SERIALNO", GMCLOldSerialNo).executeUpdate();
						
						//���¹�ģ�Ӷ��״̬ΪʧЧ
						BizObjectQuery qCLSon = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is not null")
								.setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO").setParameter("ObjectNo", PBIOldSerialNo);
						@SuppressWarnings("unchecked")
						List<BizObject> DataLast = qCLSon.getResultList(false);
						if(DataLast!=null){
							for(BizObject bo:DataLast){
								String GMCLOldSonSerialNo = bo.getAttribute("SerialNo").getString();
								tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
								.setParameter("STATUS", "50").setParameter("SERIALNO", GMCLOldSonSerialNo).executeUpdate();
							}
						}
						
					}
					
					//��������Ϣת�����������Ŀ
					BizObjectQuery PRBA = bmPR.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType='jbo.app.BUSINESS_APPLY' and RelativeType='01'").setParameter("ProjectSerialNo", PBIOldSerialNo);
					@SuppressWarnings("unchecked")
					List<BizObject> DataLastPRBA = PRBA.getResultList(false);
					if(DataLastPRBA!=null){
						for(BizObject bo:DataLastPRBA){
							String SerialNo = bo.getAttribute("SerialNo").getString();
							bmPR.createQuery("UPDATE O SET ProjectSerialNo =:ProjectSerialNo WHERE ObjectType='jbo.app.BUSINESS_APPLY' and RelativeType='01' and SerialNo =:SerialNo")
							.setParameter("ProjectSerialNo", serialNo).setParameter("SerialNo", SerialNo).executeUpdate();
						}
					}
					
					//��������Ϣת�����������Ŀ
					BizObjectQuery PRBC = bmPR.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType='jbo.app.BUSINESS_CONTRACT' and RelativeType='02'").setParameter("ProjectSerialNo", PBIOldSerialNo);
					@SuppressWarnings("unchecked")
					List<BizObject> DataLastPRBC = PRBC.getResultList(false);
					if(DataLastPRBC!=null){
						for(BizObject bo:DataLastPRBC){
							String SerialNo = bo.getAttribute("SerialNo").getString();
							bmPR.createQuery("UPDATE O SET ProjectSerialNo =:ProjectSerialNo WHERE ObjectType='jbo.app.BUSINESS_CONTRACT' and RelativeType='02' and SerialNo =:SerialNo")
							.setParameter("ProjectSerialNo", serialNo).setParameter("SerialNo", SerialNo).executeUpdate();
						}
					}
					
					//�����ǰ�ĵ����͵��������Ϊ��ʧЧ
					BizObjectManager tablePR = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
					tx.join(tablePR);
					
					BizObjectQuery qPR = tablePR.createQuery("ObjectType=:ObjectType and ProjectSerialNo=:ProjectSerialNo")
							.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ProjectSerialNo", PBIOldSerialNo);
					BizObject prPR = qPR.getSingleResult(false);
					String  GCOldSerialNo = "";
					if(prPR != null){
						GCOldSerialNo = prPR.getAttribute("ObjectNo").getString();
						//���µ���״̬ΪʧЧ
						BizObjectManager tableGC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
						tx.join(tableGC);
						
						tableGC.createQuery("UPDATE O SET CONTRACTSTATUS=:CONTRACTSTATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO =:SERIALNO")
							.setParameter("CONTRACTSTATUS", "03").setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", GCOldSerialNo).executeUpdate();
						
						//���µ������״̬ΪʧЧ
						BizObjectQuery qCL = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is null")
								.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ObjectNo", GCOldSerialNo);
						BizObject prCL = qCL.getSingleResult(false);
						String GCCLOldSerialNo = "";
						if(prCL != null){
							GCCLOldSerialNo = prCL.getAttribute("SerialNo").getString();
							//���µ��������״̬
							tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
								.setParameter("STATUS", "50").setParameter("SERIALNO", GCCLOldSerialNo).executeUpdate();
							//���µ����Ӷ��״̬
							BizObjectQuery qCLSon = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is not null")
									.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ObjectNo", GCOldSerialNo);
							@SuppressWarnings("unchecked")
							List<BizObject> DataLast = qCLSon.getResultList(false);
							if(DataLast!=null){
								for(BizObject bo:DataLast){
									String GCCLOldSonSerialNo = bo.getAttribute("SerialNo").getString();
									tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
										.setParameter("STATUS", "50").setParameter("SERIALNO", GCCLOldSonSerialNo).executeUpdate();
								}
							}
						}
					}
					
					//����gc���projectserialNoΪ��������Ŀ���
					BizObjectManager tableGCPJ = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
					tx.join(tableGCPJ);
					
					tableGCPJ.createQuery("UPDATE O SET ProjectSerialNo =:ProjectSerialNo WHERE ProjectSerialNo =:SerialNo")
					.setParameter("ProjectSerialNo", serialNo).setParameter("SerialNo", PBIOldSerialNo).executeUpdate();
					
					//������������Ϣ�ҵ����µ���Ŀ��
					BizObjectManager tablePV = JBOFactory.getBizObjectManager("jbo.prj.PRJ_VEHICLE");
					tx.join(tablePV);
					
					BizObjectQuery qPV = tablePV.createQuery("ProjectSerialNo=:ProjectSerialNo").setParameter("ProjectSerialNo", PBIOldSerialNo);
					BizObject prPV = qPV.getSingleResult(false);
					String PVSerialNo = "";
					if(prPV != null){
						PVSerialNo = prPV.getAttribute("SerialNo").getString();
						tablePV.createQuery("UPDATE O SET PROJECTSERIALNO =:PROJECTSERIALNO WHERE SERIALNO =:SERIALNO")
						.setParameter("PROJECTSERIALNO", serialNo).setParameter("SERIALNO", PVSerialNo).executeUpdate();
					}
					//���豸������Ϣ�ҵ����µ���Ŀ��
					BizObjectManager tablePE = JBOFactory.getBizObjectManager("jbo.prj.PRJ_EQUIPMENT");
					tx.join(tablePE);
					
					BizObjectQuery qPE = tablePE.createQuery("ProjectSerialNo=:ProjectSerialNo").setParameter("ProjectSerialNo", PBIOldSerialNo);
					BizObject prPE = qPE.getSingleResult(false);
					String PESerialNo = "";
					if(prPE != null){
						PESerialNo = prPE.getAttribute("SerialNo").getString();
						tablePE.createQuery("UPDATE O SET PROJECTSERIALNO =:PROJECTSERIALNO WHERE SERIALNO =:SERIALNO")
						.setParameter("PROJECTSERIALNO", serialNo).setParameter("SERIALNO", PESerialNo).executeUpdate();
					}
					//��¥����Ϣ�ҵ����µ���Ŀ��
					BizObjectManager tablePB = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BUILDING");
					tx.join(tablePB);
					
					BizObjectQuery qPB = tablePB.createQuery("ProjectSerialNo=:ProjectSerialNo").setParameter("ProjectSerialNo", PBIOldSerialNo);
					BizObject prPB = qPB.getSingleResult(false);
					String PBSerialNo = "";
					if(prPB != null){
						PBSerialNo = prPB.getAttribute("SerialNo").getString();
						tablePB.createQuery("UPDATE O SET PROJECTSERIALNO =:PROJECTSERIALNO WHERE SERIALNO =:SERIALNO")
						.setParameter("PROJECTSERIALNO", serialNo).setParameter("SERIALNO", PBSerialNo).executeUpdate();
					}
					//����Ӯ���˳�Ա��Ϣ�ҵ����µ���Ŀ��
					BizObjectManager tablePP = JBOFactory.getBizObjectManager("jbo.prj.PRJ_PARTICIPANT");
					tx.join(tablePP);
					
					BizObjectQuery qPP = tablePP.createQuery("ProjectSerialNo=:ProjectSerialNo").setParameter("ProjectSerialNo", PBIOldSerialNo);
					@SuppressWarnings("unchecked")
					List<BizObject> DataLastPP = qPP.getResultList(false);
					if(DataLastPP!=null){
						for(BizObject bo:DataLastPP){
							String PPSerialNo = bo.getAttribute("SerialNo").getString();
							tablePP.createQuery("UPDATE O SET PROJECTSERIALNO =:PROJECTSERIALNO WHERE SERIALNO =:SERIALNO")
							.setParameter("PROJECTSERIALNO", serialNo).setParameter("SERIALNO", PPSerialNo).executeUpdate();
						}
					}
					
					//����֤����ϸ��Ϣ�ҵ����µ���Ŀ��
					BizObjectManager tableCMI = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_INFO");
					tx.join(tableCMI);
					
					BizObjectQuery qCMI = tableCMI.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO'").setParameter("ObjectNo", PBIOldSerialNo);
					BizObject prCMI = qCMI.getSingleResult(false);
					if(prCMI != null){
						//���ǰ��Ŀ�ı�֤���˺�
						String MarginSerialNo = prCMI.getAttribute("SerialNo").getString();
						
						BizObjectManager tablePBI01 = JBOFactory.getBizObjectManager("jbo.prj.PRJ_BASIC_INFO");
						tx.join(tablePBI01);
						
						BizObjectQuery qPBI01 = tablePBI01.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", PBIOldSerialNo);
						BizObject prPBI01 = qPBI01.getSingleResult(false);
						
						if(prPBI01 != null){
							//��ѯ��Ŀ����
							String ProjectType = prPBI01.getAttribute("ProjectType").getString();
							
							String ObjectType = "";
							//ͨ����Ŀ�����ж��ǹ�Ӯ���˳�Ա���Ǻ�����
							if("0107".equals(ProjectType)){
								ObjectType="jbo.customer.CUSTOMER_INFO";
							}else{
								ObjectType = "jbo.customer.CUSTOMER_LIST";
							}
							
							//��ѯ�������Ŀ�ı�֤����ˮ��
							BizObjectQuery qCMI01 = tableCMI.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.prj.PRJ_BASIC_INFO'").setParameter("ObjectNo", serialNo);
							BizObject prCMI01 = qCMI01.getSingleResult(false);
							if(prCMI01 != null){
								String CMWSerialNoChange = prCMI01.getAttribute("SerialNo").getString();
								
								//ͨ�������ı�֤����ˮ�ţ��ҵ���֤���˻��˺�
								BizObjectManager tableAAI = JBOFactory.getBizObjectManager("jbo.acct.ACCT_BUSINESS_ACCOUNT");
								tx.join(tableAAI);
								
								BizObjectQuery qAAI = tableAAI.createQuery("ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.CLR_MARGIN_INFO'").setParameter("ObjectNo", CMWSerialNoChange);
								BizObject prAAI = qAAI.getSingleResult(false);
								
								if(prAAI != null){
									String AccountNo = prAAI.getAttribute("AccountNo").getString();
									
									//��ѯ���ǰ��Ŀ�ı�֤�������ϸ
									BizObjectManager tableCMW = JBOFactory.getBizObjectManager("jbo.guaranty.CLR_MARGIN_WASTEBOOK");
									tx.join(tableCMW);
									
									BizObjectQuery qCMW = tableCMW.createQuery("MarginSerialNo=:MarginSerialNo and ObjectType=:ObjectType and TransactionCode='0010'")
											.setParameter("MarginSerialNo", MarginSerialNo).setParameter("ObjectType", ObjectType);
									@SuppressWarnings("unchecked")
									List<BizObject> DataLastCMW = qCMW.getResultList(false);
									if(DataLastCMW!=null){
										for(BizObject bo:DataLastCMW){
											//��ȡ��֤�������ϸ����ˮ��
											String CMWSerialNo = bo.getAttribute("SerialNo").getString();
											//�����ǰ�ı�֤�������ϸ��Ϣ�ҵ���������Ŀ��
											tableCMW.createQuery("UPDATE O SET ACCOUNTNO=:ACCOUNTNO,MARGINSERIALNO =:MARGINSERIALNO WHERE SERIALNO =:SERIALNO")
											.setParameter("ACCOUNTNO", AccountNo).setParameter("MARGINSERIALNO", CMWSerialNoChange).setParameter("SERIALNO", CMWSerialNo).executeUpdate();
										}
									}
								}
							}
						}
					}
				}
			}
			
			//������Ŀ��Ч��������Ŀ��ģ���״̬
			BizObjectManager tableCL = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(tableCL);
			BizObjectQuery qCL = tableCL.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and ParentSerialNo is null")
					.setParameter("ObjectNo", serialNo).setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO");
			BizObject prCL = qCL.getSingleResult(false);
			String  CLSerialNo = "";
			if(prCL!=null)
			{
				CLSerialNo = prCL.getAttribute("SerialNo").getString();
				
				int month = (int) Math.floor(DateHelper.getMonths(EffectDate, ExpiryDate));
                int day = DateHelper.getDays(DateHelper.getRelativeDate(EffectDate, DateHelper.TERM_UNIT_MONTH, month), ExpiryDate);

				tableCL.createQuery("UPDATE O SET STATUS=:STATUS,STARTDATE=:STARTDATE,MATURITYDATE=:MATURITYDATE,CLTERM=:CLTERM,CLTERMDAY=:CLTERMDAY WHERE SERIALNO =:SERIALNO")
					.setParameter("STATUS", "20").setParameter("STARTDATE", EffectDate).setParameter("MATURITYDATE", ExpiryDate)
						.setParameter("CLTERM", month).setParameter("CLTERMDAY", day).setParameter("SERIALNO", CLSerialNo).executeUpdate();
				
				//���¹�ģ�Ӷ��״̬Ϊ��Ч
				BizObjectQuery qCLSon = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is not null")
						.setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO").setParameter("ObjectNo", serialNo);
				@SuppressWarnings("unchecked")
				List<BizObject> DataLast = qCLSon.getResultList(false);
				if(DataLast!=null){
					for(BizObject bo:DataLast){
						String GMCLOldSonSerialNo = bo.getAttribute("SerialNo").getString();
						tableCL.createQuery("UPDATE O SET STATUS =:STATUS,STARTDATE=:STARTDATE,MATURITYDATE=:MATURITYDATE,CLTERM=:CLTERM,CLTERMDAY=:CLTERMDAY WHERE SERIALNO =:SERIALNO")
							.setParameter("STATUS", "20").setParameter("STARTDATE", EffectDate).setParameter("MATURITYDATE", ExpiryDate)
								.setParameter("CLTERM", month).setParameter("CLTERMDAY", day).setParameter("SERIALNO", GMCLOldSonSerialNo).executeUpdate();
					}
				}
			}

			//������Ŀ��Ч��������Ŀ�������״̬�͵���״̬
			BizObjectManager tablePR = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
			tx.join(tablePR);
			BizObjectQuery qPR = tablePR.createQuery("ObjectType=:ObjectType and ProjectSerialNo=:ProjectSerialNo")
					.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ProjectSerialNo", serialNo);
			BizObject prPR = qPR.getSingleResult(false);
			String  GCSerialNo = "";
			if(prPR!=null)
			{
				GCSerialNo = prPR.getAttribute("ObjectNo").getString();
				BizObjectQuery qGCCL = tableCL.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and ParentSerialNo is null")
						.setParameter("ObjectNo", GCSerialNo).setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
				BizObject prGCCL = qGCCL.getSingleResult(false);
				String  GCCLSerialNo = "";
				if(prGCCL!=null)
				{
					GCCLSerialNo = prGCCL.getAttribute("SerialNo").getString();
					//������Ŀ���������״̬
					int month = (int) Math.floor(DateHelper.getMonths(EffectDate, ExpiryDate));
	                int day = DateHelper.getDays(DateHelper.getRelativeDate(EffectDate, DateHelper.TERM_UNIT_MONTH, month), ExpiryDate);
					
					tableCL.createQuery("UPDATE O SET STATUS=:STATUS,STARTDATE=:STARTDATE,MATURITYDATE=:MATURITYDATE,CLTERM=:CLTERM,CLTERMDAY=:CLTERMDAY WHERE SERIALNO =:SERIALNO")
						.setParameter("STATUS", "20").setParameter("STARTDATE", EffectDate).setParameter("MATURITYDATE", ExpiryDate)
							.setParameter("CLTERM", month).setParameter("CLTERMDAY", day).setParameter("SERIALNO", GCCLSerialNo).executeUpdate();
				
					//���µ����Ӷ��״̬Ϊ��Ч
					BizObjectQuery qCLSon = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is not null")
							.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ObjectNo", GCSerialNo);
					@SuppressWarnings("unchecked")
					List<BizObject> DataLast = qCLSon.getResultList(false);
					if(DataLast!=null){
						for(BizObject bo:DataLast){
							String GCCLSonSerialNo = bo.getAttribute("SerialNo").getString();
							tableCL.createQuery("UPDATE O SET STATUS =:STATUS,STARTDATE=:STARTDATE,MATURITYDATE=:MATURITYDATE,CLTERM=:CLTERM,CLTERMDAY=:CLTERMDAY WHERE SERIALNO =:SERIALNO")
								.setParameter("STATUS", "20").setParameter("STARTDATE", EffectDate).setParameter("MATURITYDATE", ExpiryDate)
									.setParameter("CLTERM", month).setParameter("CLTERMDAY", day).setParameter("SERIALNO", GCCLSonSerialNo).executeUpdate();
						}
					}
					
					//������Ŀ����״̬
					BizObjectManager tableGC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
					tx.join(tableGC);
				
					tableGC.createQuery("UPDATE O SET CONTRACTSTATUS=:CONTRACTSTATUS,CONTRACTDATE=:CONTRACTDATE,MATURITYDATE=:MATURITYDATE,UPDATEDATE=:UPDATEDATE WHERE SERIALNO =:SERIALNO")
						.setParameter("CONTRACTSTATUS", "02").setParameter("CONTRACTDATE", EffectDate).setParameter("MATURITYDATE", ExpiryDate).setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", GCSerialNo).executeUpdate();
				}
			}

			//������Ŀ��Ч���Զ����ɶ���ҵ��
			//1������ҵ��������
			BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager(tx);
			//2����ָ����Ŀ��ˮ�Ŷ�Ӧ����Ŀ��Ϣ
			BusinessObject pbibo = bom.keyLoadBusinessObject("jbo.prj.PRJ_BASIC_INFO", this.serialNo);
			//3����ȡ��ز�����Ϣ
			String sObjectNo = pbibo.getString("SERIALNO");//��Ŀ��ˮ
			String sObjectType = "jbo.prj.PRJ_BASIC_INFO";//��������
			String sOriginateOrgID = pbibo.getString("ORIGINATEORGID");//��Ŀ������
			String sProjectName = pbibo.getString("PROJECTNAME");//��Ŀ����
			String sContractArtificialNo = pbibo.getString("AGREEMENTNO");//������Ŀ���
			DocSelectChangeName.insertDocPackageAndOperation(sObjectNo, sObjectType, "", sOriginateOrgID, sProjectName,sContractArtificialNo);
			
			
			//���������Ч���´���
			BizObjectManager table = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
			tx.join(table);
			BizObjectQuery q = table.createQuery("ProjectSerialNo=:ProjectSerialNo and ObjectType=:ObjectType")
					.setParameter("ProjectSerialNo", serialNo).setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
			BizObject pr = q.getSingleResult(false);
			String  ObjectNo = "";
			if(pr!=null)
			{
				ObjectNo = pr.getAttribute("ObjectNo").getString();
			}
			
			BizObjectManager bm1 = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
			tx.join(bm1);
			bm1.createQuery("UPDATE O SET CONTRACTSTATUS =:CONTRACTSTATUS WHERE SERIALNO =:SERIALNO")
			.setParameter("CONTRACTSTATUS", "02").setParameter("SERIALNO", ObjectNo).executeUpdate();
			
		}else{
			bm.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
			.setParameter("STATUS", "14").setParameter("SERIALNO", serialNo).executeUpdate();
			
			//����ģ�����Ϊ��ʧЧ
			BizObjectManager tableCL = JBOFactory.getBizObjectManager("jbo.cl.CL_INFO");
			tx.join(tableCL);
			
			BizObjectQuery qGMCL = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is null")
					.setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO").setParameter("ObjectNo", serialNo);
			BizObject prGMCL = qGMCL.getSingleResult(false);
			String GMCLSerialNo="";
			if(prGMCL != null){
				GMCLSerialNo = prGMCL.getAttribute("SerialNo").getString();
				//���¹�ģ�����״̬ΪʧЧ
				tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
					.setParameter("STATUS", "50").setParameter("SERIALNO", GMCLSerialNo).executeUpdate();
				
				//���¹�ģ�Ӷ��״̬ΪʧЧ
				BizObjectQuery qCLSon = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is not null")
						.setParameter("ObjectType", "jbo.prj.PRJ_BASIC_INFO").setParameter("ObjectNo", serialNo);
				@SuppressWarnings("unchecked")
				List<BizObject> DataLast = qCLSon.getResultList(false);
				if(DataLast!=null){
					for(BizObject bo:DataLast){
						String GMCLSonSerialNo = bo.getAttribute("SerialNo").getString();
						tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
						.setParameter("STATUS", "50").setParameter("SERIALNO", GMCLSonSerialNo).executeUpdate();
					}
				}
			}
			
			//�������͵��������ΪʧЧ
			BizObjectManager tablePR = JBOFactory.getBizObjectManager("jbo.prj.PRJ_RELATIVE");
			tx.join(tablePR);
			
			BizObjectQuery qPR = tablePR.createQuery("ObjectType=:ObjectType and ProjectSerialNo=:ProjectSerialNo")
					.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ProjectSerialNo", serialNo);
			BizObject prPR = qPR.getSingleResult(false);
			String  GCSerialNo = "";
			if(prPR != null){
				GCSerialNo = prPR.getAttribute("ObjectNo").getString();
				//���µ���״̬ΪʧЧ
				BizObjectManager tableGC = JBOFactory.getBizObjectManager("jbo.guaranty.GUARANTY_CONTRACT");
				tx.join(tableGC);
				
				tableGC.createQuery("UPDATE O SET CONTRACTSTATUS=:CONTRACTSTATUS,UPDATEDATE=:UPDATEDATE WHERE SERIALNO =:SERIALNO")
					.setParameter("CONTRACTSTATUS", "03").setParameter("UPDATEDATE", DateHelper.getBusinessDate()).setParameter("SERIALNO", GCSerialNo).executeUpdate();
				
				//���µ������״̬ΪʧЧ
				BizObjectQuery qCL = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is null")
						.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ObjectNo", GCSerialNo);
				BizObject prCL = qCL.getSingleResult(false);
				String GCCLSerialNo = "";
				if(prCL != null){
					GCCLSerialNo = prCL.getAttribute("SerialNo").getString();
					//���µ��������״̬
					tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
						.setParameter("STATUS", "50").setParameter("SERIALNO", GCCLSerialNo).executeUpdate();
					//���µ����Ӷ��״̬
					BizObjectQuery qCLSon = tableCL.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo and ParentSerialNo is not null")
							.setParameter("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT").setParameter("ObjectNo", GCSerialNo);
					@SuppressWarnings("unchecked")
					List<BizObject> DataLast = qCLSon.getResultList(false);
					if(DataLast!=null){
						for(BizObject bo:DataLast){
							String GCCLSonSerialNo = bo.getAttribute("SerialNo").getString();
							tableCL.createQuery("UPDATE O SET STATUS =:STATUS WHERE SERIALNO =:SERIALNO")
								.setParameter("STATUS", "50").setParameter("SERIALNO", GCCLSonSerialNo).executeUpdate();
						}
					}
				}
			}
			
		}


	}
}
