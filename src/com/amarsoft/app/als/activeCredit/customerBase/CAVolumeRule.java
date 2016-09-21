package com.amarsoft.app.als.activeCredit.customerBase;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.awe.util.DBKeyHelp;

import java.sql.ResultSet;

public class CAVolumeRule{
	
	public static final double NUM1 = 300000;
	public static final double NUM2 = 200000;
	public static final double NUM3 = 0;
	public void run(BusinessObject para, Connection conn) throws Exception{
		
		String Today = DateHelper.getBusinessDate();
		String BusinessSendDate = para.getString("BusinessSendDate");
		String ApproveOrgID = para.getString("ApproveOrgID");
		int CustomerBaseLevel = para.getInt("CustomerBaseLevel");
		double ActiveCreditTotal = para.getDouble("ActiveCreditTotal");		
		double NBusinessBalance = para.getDouble("NBusinessBalance");
		String CustomerBaseID = para.getString("CustomerBaseID");
		
		String sqlSelect = "SELECT * FROM CUSTOMER_LIST_RELATIVE WHERE CERTID = ? AND BUSINESSSTATUS = ?";
		String sqlInsert = "INSERT INTO CUSTOMER_LIST_RELATIVE(SERIALNO,CERTID,CAISERIALNO,PRONETBUSINESSSUM,PROLINEBUSINESSSUM,BUSINESSSTATUS,UPDATEDATE,EFFECTDATE,EXPIFYDATE,NBUSINESSBALANCE)"
				+" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		String sqlUpdate = "UPDATE CUSTOMER_LIST_RELATIVE SET BUSINESSSTATUS = ?, UPDATEDATE = ?, EXPIFYDATE = ? where SERIALNO = ? ";
		try{
			if(DateHelper.getDays(BusinessSendDate, Today)<0){
				//-1��ʾ��ȵ�����С��BusinessDate�����ڣ��˶�ȱ��ΪʧЧ
				String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
				PreparedStatement ps1 = conn.prepareStatement(sqlInsert);
				ps1.setString(1, SerialNo);
				ps1.setString(2, para.getString("CertID"));
				ps1.setString(3, para.getString("CAISerialNo"));
				ps1.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
				ps1.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
				ps1.setString(6, "2");
				ps1.setString(7, "");
				ps1.setString(8, "");
				ps1.setString(9, Today);
				ps1.setDouble(10, para.getDouble("NBusinessBalance"));
				ps1.executeUpdate();
				ps1.close();
			}else{
				//�������֤�Ų�ѯ�ÿͻ��Ƿ������Ч���
				PreparedStatement ps2 = conn.prepareStatement(sqlSelect);
				ps2.setString(1, para.getString("CertID"));
				ps2.setString(2, "1");
				ResultSet rs2 = ps2.executeQuery();
				if(rs2.next()){
					String OldSerialNo = rs2.getString("SerialNo");
					String OldCAISerialNo = rs2.getString("CAISerialNo");

					PreparedStatement psCA = conn.prepareStatement("SELECT CA.CUSTOMERBASEID FROM CUSTOMER_APPROVAL CA,CUSTOMER_APPROVAL_INFO CAI WHERE CA.BATCHNO=CAI.BATCHNO AND CAI.SERIALNO = ?");
					psCA.setString(1, OldCAISerialNo);
					ResultSet rsCA = psCA.executeQuery();
					if(rsCA.next()){
						String OldCustomerBaseID = rsCA.getString("CustomerBaseID");
						//������ϴ��İ���������������Ⱥ�뵱ǰ��ѡԤ������Ⱥ��ͬ�������ϴ���������Ϊ���£�������ΪʧЧ
						if(OldCustomerBaseID.equals(CustomerBaseID)){
							//�����ϴ����Ϊ׼�������˶��
							String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
							PreparedStatement ps13 = conn.prepareStatement(sqlInsert);
							ps13.setString(1, SerialNo);
							ps13.setString(2, para.getString("CertID"));
							ps13.setString(3, para.getString("CAISerialNo"));
							ps13.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
							ps13.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
							ps13.setString(6, "1");
							ps13.setString(7, "");
							ps13.setString(8, Today);
							ps13.setString(9, "");
							ps13.setDouble(10, para.getDouble("NBusinessBalance"));
							ps13.executeUpdate();
							ps13.close();
							
							//�϶��ʧЧ
							PreparedStatement ps14 = conn.prepareStatement(sqlUpdate);
							ps14.setString(1, "2");
							ps14.setString(2, Today);
							ps14.setString(3, Today);
							ps14.setString(4, OldSerialNo);
							ps14.executeUpdate();
							ps14.close();
						}else{
							PreparedStatement psX1 = conn.prepareStatement("SELECT CA.APPROVALORGID FROM CUSTOMER_APPROVAL CA,CUSTOMER_APPROVAL_INFO CAI WHERE CA.BATCHNO=CAI.BATCHNO AND CAI.SERIALNO = ?");
							psX1.setString(1, OldCAISerialNo);
							ResultSet rsX1 = psX1.executeQuery();
							if(rsX1.next()){
								String OldApprovalOrgID = rsX1.getString("APPROVALORGID");
								//����������ͬʱ�ĸ����߼�
								if(!ApproveOrgID.equals(OldApprovalOrgID)){
									if("9900".equals(OldApprovalOrgID) && !"9900".equals(ApproveOrgID)){//�϶��Ϊ���У��¶��Ϊ����
										//�Է��ж��Ϊ׼�������˶��
										String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
										PreparedStatement ps3 = conn.prepareStatement(sqlInsert);
										ps3.setString(1, SerialNo);
										ps3.setString(2, para.getString("CertID"));
										ps3.setString(3, para.getString("CAISerialNo"));
										ps3.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
										ps3.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
										ps3.setString(6, "1");
										ps3.setString(7, "");
										ps3.setString(8, Today);
										ps3.setString(9, "");
										ps3.setDouble(10, para.getDouble("NBusinessBalance"));
										ps3.executeUpdate();
										ps3.close();
										
										//�϶��ʧЧ
										PreparedStatement ps4 = conn.prepareStatement(sqlUpdate);
										ps4.setString(1, "2");
										ps4.setString(2, Today);
										ps4.setString(3, Today);
										ps4.setString(4, OldSerialNo);
										ps4.executeUpdate();
										ps4.close();
										
									}else{
										//�϶��Ϊ���У��¶��Ϊ���л��϶��Ϊ���У��¶��Ϊ��ͬ�ķ��У������϶��Ϊ׼�������µĶ�ȣ���Ϊδ����
										String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
										PreparedStatement ps5 = conn.prepareStatement(sqlInsert);
										ps5.setString(1, SerialNo);
										ps5.setString(2, para.getString("CertID"));
										ps5.setString(3, para.getString("CAISerialNo"));
										ps5.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
										ps5.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
										ps5.setString(6, "3");
										ps5.setString(7, "");
										ps5.setString(8, "");
										ps5.setString(9, "");
										ps5.setDouble(10, para.getDouble("NBusinessBalance"));
										ps5.executeUpdate();
										ps5.close();
									}
								}else{//����������ͬʱ�ĸ����߼�
									//ȡ�϶�ȵĿ�Ⱥ�ȼ�
									PreparedStatement psX2 = conn.prepareStatement("SELECT CB.CUSTOMERBASELEVEL FROM CUSTOMER_BASE CB,CUSTOMER_APPROVAL CA,CUSTOMER_APPROVAL_INFO CAI WHERE CA.CUSTOMERBASEID=CB.CUSTOMERBASEID AND CA.BATCHNO=CAI.BATCHNO AND CAI.SERIALNO = ?");
									psX2.setString(1, OldCAISerialNo);
									ResultSet rsX2 = psX2.executeQuery();
									if(rsX2.next()){
										int OldCustomerBaseLevel = rsX2.getInt("CustomerBaseLevel");
										//�¶�ȿ�Ⱥ�ȼ������϶�ȿ�Ⱥ�ȼ�ʱ
										if(CustomerBaseLevel > OldCustomerBaseLevel){
											//������Ⱥ�ȼ��ߵĶ�ȣ�����Ϊ��Ч
											String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
											PreparedStatement ps6 = conn.prepareStatement(sqlInsert);
											ps6.setString(1, SerialNo);
											ps6.setString(2, para.getString("CertID"));
											ps6.setString(3, para.getString("CAISerialNo"));
											ps6.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
											ps6.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
											ps6.setString(6, "1");
											ps6.setString(7, "");
											ps6.setString(8, Today);
											ps6.setString(9, "");
											ps6.setDouble(10, para.getDouble("NBusinessBalance"));
											ps6.executeUpdate();
											ps6.close();
											
											//��Ⱥ�ȼ��͵��϶����ΪʧЧ
											PreparedStatement ps7 = conn.prepareStatement(sqlUpdate);
											ps7.setString(1, "2");
											ps7.setString(2, Today);
											ps7.setString(3, Today);
											ps7.setString(4, OldSerialNo);
											ps7.executeUpdate();
											ps7.close();
										}else if(CustomerBaseLevel < OldCustomerBaseLevel){
											//�Կ�Ⱥ�ȼ��ߵ��϶��Ϊ׼��������Ⱥ�ȼ��͵Ķ�ȣ�����Ϊδ����
											String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
											PreparedStatement ps8 = conn.prepareStatement(sqlInsert);
											ps8.setString(1, SerialNo);
											ps8.setString(2, para.getString("CertID"));
											ps8.setString(3, para.getString("CAISerialNo"));
											ps8.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
											ps8.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
											ps8.setString(6, "3");
											ps8.setString(7, "");
											ps8.setString(8, "");
											ps8.setString(9, "");
											ps8.setDouble(10, para.getDouble("NBusinessBalance"));
											ps8.executeUpdate();
											ps8.close();
										}else{//�¶�ȿ�Ⱥ�ȼ������϶�ȿ�Ⱥ�ȼ�ʱ
											
											PreparedStatement psX3 = conn.prepareStatement("SELECT CAI.ACTIVECREDITTOTAL FROM CUSTOMER_APPROVAL_INFO CAI WHERE CAI.SERIALNO = ?");
											psX3.setString(1, OldCAISerialNo);
											ResultSet rsX3 = psX3.executeQuery();
											if(rsX3.next()){
												
												double OldActiveCreditTotal = rsX3.getDouble("ACTIVECREDITTOTAL");
												if(ActiveCreditTotal > OldActiveCreditTotal){//���¶�ȴ����϶��
													//�����µĶ�ȣ�����Ϊ��Ч
													String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
													PreparedStatement ps9= conn.prepareStatement(sqlInsert);
													ps9.setString(1, SerialNo);
													ps9.setString(2, para.getString("CertID"));
													ps9.setString(3, para.getString("CAISerialNo"));
													ps9.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
													ps9.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
													ps9.setString(6, "1");
													ps9.setString(7, "");
													ps9.setString(8, Today);
													ps9.setString(9, "");
													ps9.setDouble(10, para.getDouble("NBusinessBalance"));
													ps9.executeUpdate();
													ps9.close();
													//�϶����ΪʧЧ
													PreparedStatement ps10 = conn.prepareStatement(sqlUpdate);
													ps10.setString(1, "2");
													ps10.setString(2, Today);
													ps10.setString(3, Today);
													ps10.setString(4, OldSerialNo);
													ps10.executeUpdate();
													ps10.close();
												}else{
													//�����¶�ȣ�����Ϊδ����
													String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
													PreparedStatement ps11 = conn.prepareStatement(sqlInsert);
													ps11.setString(1, SerialNo);
													ps11.setString(2, para.getString("CertID"));
													ps11.setString(3, para.getString("CAISerialNo"));
													ps11.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
													ps11.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
													ps11.setString(6, "3");
													ps11.setString(7, "");
													ps11.setString(8, "");
													ps11.setString(9, "");
													ps11.setDouble(10, para.getDouble("NBusinessBalance"));
													ps11.executeUpdate();
													ps11.close();
												}
											}
											psX3.close();
											rsX3.close();
										}
									}
									psX2.close();
									rsX2.close();
								}
							}
							psX1.close();
							rsX1.close();
						}
					}
					psCA.close();
					rsCA.close();
				}else{//�ÿͻ������ڻ�ÿͻ����ʧЧ��δ���ã����Ӷ�ȱ��Ϊ��Ч
					
					String SerialNo = DBKeyHelp.getSerialNo("CUSTOMER_LIST_RELATIVE","SERIALNO");
					PreparedStatement ps12 = conn.prepareStatement(sqlInsert);
					ps12.setString(1, SerialNo);
					ps12.setString(2, para.getString("CertID"));
					ps12.setString(3, para.getString("CAISerialNo"));
					ps12.setDouble(4, Math.min(ActiveCreditTotal-NBusinessBalance, NUM1));
					ps12.setDouble(5, Math.max(Math.min(ActiveCreditTotal-NBusinessBalance-NUM1, NUM2), NUM3));
					ps12.setString(6, "1");
					ps12.setString(7, "");
					ps12.setString(8, Today);
					ps12.setString(9, "");
					ps12.setDouble(10, para.getDouble("NBusinessBalance"));
					ps12.executeUpdate();
					ps12.close();
				}
				rs2.close();
				ps2.close();
			}
			conn.commit();
		}catch(Exception e)
	    {
	        try
	        {
	            conn.rollback();
	        }
	        catch(SQLException e1)
	        {
	            ARE.getLog().error(e1);
	        }
	        throw e;
	    }
	    finally
	    {
	        if(conn != null)
	        {
	            try
	            {
	                conn.close();
	            }
	            catch(SQLException e)
	            {
	                ARE.getLog().error(e);
	            }
	            conn = null;
	        }
	    }
	}
}
