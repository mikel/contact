class ChangeStateColumnsToAasmStates < ActiveRecord::Migration
  def self.up
    rename_column :messages,   :state, :aasm_state
    rename_column :recipients, :state, :aasm_state
  end

  def self.down
    rename_column :recipients, :aasm_state, :state
    rename_column :messages,   :aasm_state, :state
  end
end
