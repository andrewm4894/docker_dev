ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="myemail@email.com"
LABEL version="01"

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# R packages including IRKernel which gets installed globally.
RUN conda install --quiet --yes \
    'rpy2=2.8*' \
    'r-base=3.4.1' \
    'r-irkernel=0.8*' \
    'r-devtools=1.13*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# install specific package versions i want to use here
RUN conda install --quiet --yes \
    'pandas=0.23.4' \
    'matplotlib=3.0.1' \
    'seaborn=0.9.0' \
    'scikit-learn=0.20.0' \
    'bokeh=0.13.0' \
    'plotly=3.3.0' \
    'boto3=1.9.40' \
    's3fs=0.1.6' \
    'pyarrow=0.11.1' \
    'fs=2.1.1' && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# install conda build 
RUN conda install --quiet --yes conda-build

# copy over local files for my package
ADD my_utilities/ /home/$NB_USER/my_utilities/
# copy over other files
ADD work/ /home/$NB_USER/work/

# add my_utilities package to conda
RUN conda develop /home/$NB_USER/my_utilities/

# conda install nb_conda_kernels to automatically have all conda envs available in jupyter
RUN conda install nb_conda_kernels

# install some r packages not on conda
RUN echo "install.packages('devtools', lib='/opt/conda/lib/R/library', repos='https://cloud.r-project.org')" | R --slave
RUN echo "install.packages('forecast', lib='/opt/conda/lib/R/library', repos='https://cloud.r-project.org')" | R --slave

# some additional conda installs
RUN conda install --quiet --yes -c anaconda simplegeneric

# update permissions on mounted dir
RUN chown -R $NB_UID:$NB_UID /home/$NB_USER/work/