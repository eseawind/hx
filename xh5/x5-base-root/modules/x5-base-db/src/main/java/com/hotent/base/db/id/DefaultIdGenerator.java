package com.hotent.base.db.id;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import com.hotent.base.db.api.IdGenerator;

/**
 *  ID Generator
 * @author csx
 */
public class DefaultIdGenerator implements IdGenerator,InitializingBean{
  
   public JdbcTemplate jdbcTemplate;
    /**
     * 增长段值
     */
    private final Long increaseBound = 1000l;
    /**
     * 当前DBID
     */
    private Long dbid = 1l;
    /**
     * 当前递增的最大值
     */
    private Long maxDbid = -1l;
    /**
     * 机器ID
     */
    private Long machineDbid = 1l;
    /**
     * 机器名称 多台物理机器集群部署时，需要唯一区分
     */
    private String machineName="1";
    
    /**
     * ID的基准长度
     */
    private Long idBase=10000000000000L;

    /**
     * 获取唯一的ID标识
     *
     * @return
     */
    public synchronized Long getUniqueId() {
        if (dbid > maxDbid) {
            genNextDbIds();
        }
        Long nextId = dbid++;
        return nextId + machineDbid * idBase;
    }

    public void genNextDbIds() {
        String sql = "UPDATE XB_DB_ID SET START_=?,MAX_=? WHERE ID_=?";
        dbid = maxDbid;
        maxDbid += increaseBound;
        jdbcTemplate.update(sql, dbid, maxDbid, machineDbid);
    }
    
    @SuppressWarnings({ "unchecked", "rawtypes" })
	public void init(){
        String sql = "select * from XB_DB_ID where MAC_NAME_=?";
        //检查该机器是否已经存在增长的键值记录
        try {
            jdbcTemplate.queryForObject(sql, new RowMapper() {
                public Object mapRow(ResultSet rs, int i) throws SQLException {
                    dbid = rs.getLong("START_");
                    maxDbid = rs.getLong("MAX_");
                    machineDbid = rs.getLong("ID_");
                    return machineDbid;
                }
            }, machineName);
            //插入该机器的键值增长记录
            genNextDbIds();
        } catch (Exception ex) {
            String maxSql = "select max(ID_) from XB_DB_ID";
			Integer maxResult = jdbcTemplate.queryForObject(maxSql, Integer.class);
            if (maxResult == null || maxResult == 0) {
                maxResult = 1;
            } else {
                maxResult++;
            }
            machineDbid = new Long(maxResult);
            maxDbid = dbid + increaseBound;
            sql = "INSERT INTO XB_DB_ID(ID_,START_,MAX_,MAC_NAME_)VALUES(?,?,?,?)";
            jdbcTemplate.update(sql, new Object[]{machineDbid, dbid, maxDbid, machineName});
        }
    }

    public void afterPropertiesSet() throws Exception {
        init();
    }

    public Long getDbid() {
        return dbid;
    }

    public void setDbid(Long dbid) {
        this.dbid = dbid;
    }

    public Long getMaxDbid() {
        return maxDbid;
    }

    public void setMaxDbid(Long maxDbid) {
        this.maxDbid = maxDbid;
    }

    public Long getMachineDbid() {
        return machineDbid;
    }

    public void setMachineDbid(Long machineDbid) {
        this.machineDbid = machineDbid;
    }

    public String getMachineName() {
        return machineName;
    }

    public Long getIdBase() {
		return idBase;
	}

	public void setIdBase(Long idBase) {
		this.idBase = idBase;
	}

	public void setMachineName(String machineName) {
        this.machineName = machineName;
    }

    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Long getUId() {
        return getUniqueId();
    }

    public String getSuid() {
        return getUId().toString();
    }
    
}
