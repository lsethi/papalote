class FoldersController < ApplicationController

  def index
    @folders = Folder.all
    render json: @folders
  end

  def show
    @folder = Folder.find(params[:id])
    render json: @folder
  end

  def create
    @folder = Folder.new(folder_params)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: "Folder was successfully created." }
        format.json { render json: @folder}
      else
        format.json { render json: @folder.errors }
      end
    end
  end

  def update
    @folder = Folder.find(params[:id])
    respond_to do |format|
      if @folder.update(folder_params)
        format.json { render :show}
      else
        format.json { render json: @folder.errors}
      end
    end
  end

  def destroy
    Folder.destroy(params['id'])
    respond_to do |format|
      format.html { redirect_to folders_url, notice: 'Folder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def contents
    @folder = Folder.find(params[:folder_id])
    @docs = Doc.where(folder_id: params[:folder_id])
    @subfolders = Folder.where(parentfolder_id: params[:folder_id])
    response = {:docs => @docs, :folders => @subfolders}
    render json: response
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :parentfolder_id, :owner_id)
  end

end
