package com.amarsoft.app.als.awe.ow.processor;
import java.io.OutputStream;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;

/**
 * 传统的OW直接将数据保存至数据库，缺少中间业务逻辑的处理，该类用于接管原业务处理逻辑，默认不会保存至数据库，所有处理将转至外部业务逻辑处理。
 * @author ygwang
 */
public interface OWExportor {
	public int exportFile(OutputStream outputStream,ALSBusinessProcess businessProcess) throws Exception;
}
